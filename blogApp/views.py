from functools import wraps

from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from django.db import IntegrityError, transaction
from django.db.models import F, Q
from django.http import HttpResponseForbidden
from django.utils.http import url_has_allowed_host_and_scheme
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone
from django.utils.text import slugify
from django.views.decorators.http import require_POST

from .forms import CategoryForm, CommentForm, ContactForm, PostForm, SignUpForm
from .models import (
	Category,
	Comment,
	ContactMessage,
	Like,
	LoginHistory,
	Notification,
	Post,
	Subscription,
	User,
)


def role_required(*roles):
	def decorator(view_func):
		@wraps(view_func)
		@login_required
		def wrapped(request, *args, **kwargs):
			if request.user.role not in roles:
				return HttpResponseForbidden("You do not have permission to view this page.")
			return view_func(request, *args, **kwargs)

		return wrapped

	return decorator


def notify(user, title, content, link, actor=None):
	if user and user.is_active:
		Notification.objects.create(
			user=user,
			title=title,
			content=content,
			link=link,
			actor=actor,
			created_at=timezone.now(),
		)


def notify_admins(title, content, link, actor=None):
	admins = User.objects.filter(role=User.Role.ADMIN, is_active=True)
	if actor is not None:
		admins = admins.exclude(pk=actor.pk)
	for administrator in admins:
		notify(administrator, title, content, link, actor)


def home(request):
	posts = Post.objects.filter(status=Post.Status.PUBLISHED, is_visible=True).select_related("author", "category")
	query = request.GET.get("q", "").strip()
	category_id = request.GET.get("category", "")
	if query:
		posts = posts.filter(Q(title__icontains=query) | Q(description__icontains=query) | Q(body__icontains=query))
	if category_id.isdigit():
		posts = posts.filter(category_id=category_id)
	page = Paginator(posts, 9).get_page(request.GET.get("page"))
	return render(request, "blogApp/home.html", {
		"page": page,
		"posts": page.object_list,
		"categories": Category.objects.all(),
		"query": query,
		"selected_category": category_id,
	})


def post_detail(request, slug):
	post = get_object_or_404(
		Post.objects.select_related("author", "category"),
		slug=slug,
		status=Post.Status.PUBLISHED,
		is_visible=True,
	)
	Post.objects.filter(pk=post.pk).update(views=F("views") + 1)
	post.refresh_from_db()
	comments = post.comment_set.filter(is_visible=True).select_related("user")
	comment_form = CommentForm()
	liked = False
	followed = False
	if request.user.is_authenticated:
		liked = Like.objects.filter(user=request.user, post=post).exists()
		if post.author_id:
			followed = Subscription.objects.filter(user=request.user, editor_id=post.author_id).exists()
	return render(request, "blogApp/post_detail.html", {
		"post": post,
		"comments": comments,
		"comment_form": comment_form,
		"liked": liked,
		"followed": followed,
	})


def sign_up(request):
	if request.user.is_authenticated:
		return redirect("home")
	form = SignUpForm(request.POST or None)
	if request.method == "POST" and form.is_valid():
		user = form.save()
		login(request, user, backend="django.contrib.auth.backends.ModelBackend")
		notify_admins("New account", f"{user.username} created an account.", "/manage/?section=users", user)
		messages.success(request, "Your reader account is ready.")
		return redirect("home")
	return render(request, "blogApp/auth_form.html", {"form": form, "heading": "Create your account", "submit_label": "Join the community", "signup": True})


def sign_in(request):
	if request.user.is_authenticated:
		return redirect("home")
	error = ""
	if request.method == "POST":
		email = request.POST.get("email", "").strip()
		password = request.POST.get("password", "")
		user = authenticate(request, email=email, password=password)
		if user is not None:
			login(request, user)
			LoginHistory.objects.create(
				user=user,
				login_time=timezone.now(),
				ip_address=request.META.get("REMOTE_ADDR"),
			)
			notify_admins("New login", f"{user.username} signed in.", "/manage/?section=logins", user)
			next_url = request.POST.get("next") or request.GET.get("next", "")
			if url_has_allowed_host_and_scheme(next_url, allowed_hosts={request.get_host()}, require_https=request.is_secure()):
				return redirect(next_url)
			return redirect("home")
		error = "We could not sign you in with those details."
	return render(request, "blogApp/auth_form.html", {
		"heading": "Welcome back",
		"submit_label": "Sign in",
		"error": error,
		"email": request.POST.get("email", ""),
	})


@require_POST
@login_required
def sign_out(request):
	logout(request)
	messages.info(request, "You have been signed out.")
	return redirect("home")


@require_POST
@login_required
def add_comment(request, slug):
	post = get_object_or_404(Post, slug=slug, status=Post.Status.PUBLISHED, is_visible=True)
	form = CommentForm(request.POST)
	if form.is_valid():
		with transaction.atomic():
			comment = form.save(commit=False)
			comment.user = request.user
			comment.post = post
			comment.created_at = timezone.now()
			comment.save()
			Post.objects.filter(pk=post.pk).update(comments=F("comments") + 1)
		if post.author_id and post.author_id != request.user.pk:
			notify(post.author, "New comment", f"{request.user.username} commented on “{post.title}”.", f"/posts/{post.slug}/#comments", request.user)
		notify_admins("New blog comment", f"{request.user.username} commented on “{post.title}”.", "/manage/?section=comments", request.user)
		messages.success(request, "Your comment has been posted.")
	else:
		messages.error(request, "Please enter a comment before submitting.")
	return redirect("post_detail", slug=slug)


@require_POST
@login_required
def toggle_like(request, slug):
	post = get_object_or_404(Post, slug=slug, status=Post.Status.PUBLISHED, is_visible=True)
	if post.author_id == request.user.pk:
		messages.info(request, "You cannot like your own story.")
		return redirect("post_detail", slug=slug)
	try:
		with transaction.atomic():
			_, created = Like.objects.get_or_create(user=request.user, post=post, defaults={"liked_at": timezone.localdate()})
			if created:
				Post.objects.filter(pk=post.pk).update(likes=F("likes") + 1)
			else:
				Like.objects.filter(user=request.user, post=post).delete()
				Post.objects.filter(pk=post.pk, likes__gt=0).update(likes=F("likes") - 1)
	except IntegrityError:
		messages.info(request, "Your reaction could not be saved. Please try again.")
		return redirect("post_detail", slug=slug)
	if created and post.author_id:
		notify(post.author, "Your story was liked", f"{request.user.username} liked “{post.title}”.", f"/posts/{post.slug}/", request.user)
	return redirect("post_detail", slug=slug)


@require_POST
@login_required
def toggle_follow(request, user_id):
	editor = get_object_or_404(User, pk=user_id, role=User.Role.EDITOR, is_active=True)
	if request.user.pk == editor.pk:
		messages.error(request, "You cannot follow your own account.")
		return redirect("home")
	_, created = Subscription.objects.get_or_create(
		user=request.user,
		editor=editor,
		defaults={"subscribed_at": timezone.localdate()},
	)
	if created:
		notify(editor, "New subscriber", f"{request.user.username} followed your stories.", "/editor/", request.user)
		messages.success(request, f"You are now following {editor.username}.")
	else:
		Subscription.objects.filter(user=request.user, editor=editor).delete()
		messages.info(request, f"You unfollowed {editor.username}.")
	return redirect(request.POST.get("next") or "home")


def contact(request):
	form = ContactForm(request.POST or None, initial={
		"sender_name": request.user.username if request.user.is_authenticated else "",
		"sender_email": request.user.email if request.user.is_authenticated else "",
	})
	if request.method == "POST" and form.is_valid():
		message = form.save(commit=False)
		message.submitted_at = timezone.now()
		message.save()
		notify_admins("New contact message", message.subject, "/manage/?section=inbox", request.user if request.user.is_authenticated else None)
		messages.success(request, "Your message has been sent.")
		return redirect("contact")
	return render(request, "blogApp/contact.html", {"form": form})


@login_required
def notifications(request):
	if request.method == "POST":
		notification_id = request.POST.get("notification_id")
		Notification.objects.filter(pk=notification_id, user=request.user).update(is_read=True)
		return redirect("notifications")
	return render(request, "blogApp/notifications.html", {
		"notifications": request.user.notifications.all()[:100],
		"unread_count": request.user.notifications.filter(is_read=False).count(),
	})


@role_required(User.Role.EDITOR, User.Role.ADMIN)
def editor_dashboard(request):
	posts = Post.objects.filter(author=request.user).select_related("category")
	comments = Comment.objects.filter(post__author=request.user).select_related("post", "user")[:30]
	return render(request, "blogApp/editor_dashboard.html", {
		"posts": posts,
		"comments": comments,
		"post_count": posts.count(),
		"follower_count": Subscription.objects.filter(editor=request.user).count(),
		"form": PostForm(),
	})


@role_required(User.Role.EDITOR, User.Role.ADMIN)
def edit_post(request, post_id=None):
	post = None
	if post_id is not None:
		post = get_object_or_404(Post, pk=post_id)
		if post.author_id != request.user.pk and request.user.role != User.Role.ADMIN:
			return HttpResponseForbidden("You can only edit your own stories.")
	form = PostForm(request.POST or None, instance=post)
	if request.method == "POST" and form.is_valid():
		saved_post = form.save(commit=False)
		if post is None:
			saved_post.author = request.user
			saved_post.created_at = timezone.now()
		saved_post.updated_at = timezone.now()
		if post is None or saved_post.title != post.title:
			base_slug = slugify(saved_post.title)[:290] or "story"
			saved_post.slug = base_slug
			suffix = 2
			while Post.objects.filter(slug=saved_post.slug).exclude(pk=saved_post.pk).exists():
				saved_post.slug = f"{base_slug[:280]}-{suffix}"
				suffix += 1
		saved_post.save()
		messages.success(request, "Your story has been saved.")
		return redirect("editor_dashboard")
	return render(request, "blogApp/post_form.html", {"form": form, "post": post})


@role_required(User.Role.EDITOR, User.Role.ADMIN)
@require_POST
def moderate_editor_comment(request, comment_id):
	comment = get_object_or_404(Comment, pk=comment_id)
	if comment.post.author_id != request.user.pk and request.user.role != User.Role.ADMIN:
		return HttpResponseForbidden("You can only moderate comments on your stories.")
	comment.is_visible = not comment.is_visible
	comment.save(update_fields=["is_visible"])
	messages.success(request, "Comment visibility updated.")
	return redirect("editor_dashboard")


@role_required(User.Role.ADMIN)
def management_dashboard(request):
	section_names = {"overview", "users", "posts", "comments", "inbox", "logins", "categories"}
	section = request.GET.get("section", "overview")
	if section not in section_names:
		section = "overview"
	if request.method == "POST":
		action = request.POST.get("action", "")
		item_id = request.POST.get("item_id", "")
		if section == "users":
			target = get_object_or_404(User, pk=item_id)
			if target.pk == request.user.pk:
				messages.error(request, "You cannot change your own account here.")
			elif action in {"toggle_active", "set_role"}:
				will_remove_admin = target.role == User.Role.ADMIN and (
					action == "toggle_active" and target.is_active
					or action == "set_role" and request.POST.get("role") != User.Role.ADMIN
				)
				if will_remove_admin and User.objects.filter(role=User.Role.ADMIN, is_active=True).count() <= 1:
					messages.error(request, "The last active administrator cannot be removed.")
				elif action == "toggle_active":
					target.is_active = not target.is_active
					target.save(update_fields=["is_active"])
					messages.success(request, "Account status updated.")
				elif request.POST.get("role") in User.Role.values:
					target.role = request.POST["role"]
					target.save(update_fields=["role"])
					messages.success(request, "Account role updated.")
		elif section == "posts":
			post = get_object_or_404(Post, pk=item_id)
			if action == "toggle_visibility":
				post.is_visible = not post.is_visible
				post.save(update_fields=["is_visible"])
				messages.success(request, "Story visibility updated.")
			elif action == "toggle_status":
				post.status = Post.Status.DRAFT if post.status == Post.Status.PUBLISHED else Post.Status.PUBLISHED
				post.save(update_fields=["status"])
				messages.success(request, "Story publication status updated.")
		elif section == "comments" and action == "toggle_visibility":
			comment = get_object_or_404(Comment, pk=item_id)
			comment.is_visible = not comment.is_visible
			comment.save(update_fields=["is_visible"])
			messages.success(request, "Comment visibility updated.")
		elif section == "inbox" and action == "toggle_resolved":
			contact_message = get_object_or_404(ContactMessage, pk=item_id)
			contact_message.is_resolved = not contact_message.is_resolved
			contact_message.save(update_fields=["is_resolved"])
			messages.success(request, "Contact message status updated.")
		elif section == "categories" and action == "add_category":
			category_form = CategoryForm(request.POST)
			if category_form.is_valid():
				category_form.save()
				messages.success(request, "Category added.")
			else:
				messages.error(request, "Enter a category name.")
		return redirect(f"manage?section={section}")

	context = {
		"section": section,
		"section_choices": [
			("overview", "Overview"),
			("users", "People"),
			("posts", "Stories"),
			("comments", "Comments"),
			("inbox", "Inbox"),
			("logins", "Sign-ins"),
			("categories", "Topics"),
		],
		"post_actions": [("toggle_status", "Publish / draft"), ("toggle_visibility", "Hide / show")],
		"stats": {
			"users": User.objects.count(),
			"editors": User.objects.filter(role=User.Role.EDITOR).count(),
			"posts": Post.objects.count(),
			"comments": Comment.objects.count(),
			"unresolved": ContactMessage.objects.filter(is_resolved=False).count(),
		},
		"role_choices": User.Role.choices,
		"category_form": CategoryForm(),
	}
	if section == "users":
		context["items"] = User.objects.all()[:200]
	elif section == "posts":
		context["items"] = Post.objects.select_related("author", "category").all()[:200]
	elif section == "comments":
		context["items"] = Comment.objects.select_related("user", "post").all()[:200]
	elif section == "inbox":
		context["items"] = ContactMessage.objects.all()[:200]
	elif section == "logins":
		context["items"] = LoginHistory.objects.select_related("user").all()[:200]
	elif section == "categories":
		context["items"] = Category.objects.all()
	else:
		context["recent_posts"] = Post.objects.select_related("author").all()[:8]
		context["recent_logins"] = LoginHistory.objects.select_related("user").all()[:8]
		context["recent_messages"] = ContactMessage.objects.filter(is_resolved=False)[:5]
	return render(request, "blogApp/management_dashboard.html", context)
