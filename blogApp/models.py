from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.db import models
from django.utils import timezone


class UserManager(BaseUserManager):
	use_in_migrations = False

	def create_user(self, email, username, password=None, **extra_fields):
		if not email:
			raise ValueError("An email address is required.")
		user = self.model(
			email=self.normalize_email(email),
			username=username,
			date_joined=timezone.now(),
			**extra_fields,
		)
		user.set_password(password)
		user.save(using=self._db)
		return user

	def create_superuser(self, email, username, password=None, **extra_fields):
		extra_fields["role"] = User.Role.ADMIN
		extra_fields["is_active"] = True
		return self.create_user(email, username, password, **extra_fields)


class User(AbstractBaseUser):
	class Role(models.TextChoices):
		ADMIN = "admin", "Administrator"
		EDITOR = "editor", "Editor"
		USER = "user", "Reader"

	id = models.AutoField(primary_key=True, db_column="user_id")
	username = models.CharField(max_length=200, db_column="user_name")
	email = models.EmailField(max_length=250, unique=True)
	password = models.CharField(max_length=300, db_column="password_h")
	role = models.CharField(max_length=150, choices=Role.choices, db_column="user_role")
	date_joined = models.DateTimeField(null=True, db_column="join_date")
	is_active = models.BooleanField(default=True)
	last_login = None

	objects = UserManager()

	USERNAME_FIELD = "email"
	REQUIRED_FIELDS = ["username"]

	class Meta:
		db_table = "users"
		managed = False
		ordering = ["username"]

	def __str__(self):
		return self.username

	@property
	def is_staff(self):
		return self.role == self.Role.ADMIN

	@property
	def is_superuser(self):
		return self.role == self.Role.ADMIN

	def has_perm(self, perm, obj=None):
		return self.is_superuser

	def has_module_perms(self, app_label):
		return self.is_superuser

	def get_full_name(self):
		return self.username

	def get_short_name(self):
		return self.username.split()[0]


class Category(models.Model):
	id = models.AutoField(primary_key=True, db_column="category_id")
	name = models.CharField(max_length=300)

	class Meta:
		db_table = "categories"
		managed = False
		ordering = ["name"]

	def __str__(self):
		return self.name


class Post(models.Model):
	class Status(models.TextChoices):
		DRAFT = "draft", "Draft"
		PUBLISHED = "live", "Published"

	id = models.AutoField(primary_key=True, db_column="blog_id")
	author = models.ForeignKey(
		User, models.SET_NULL, null=True, blank=True, db_column="author_id", related_name="posts"
	)
	category = models.ForeignKey(
		Category, models.SET_NULL, null=True, blank=True, db_column="category_id", related_name="posts"
	)
	title = models.TextField()
	slug = models.SlugField(max_length=300, unique=True)
	description = models.TextField(db_column="blog_description")
	body = models.TextField()
	created_at = models.DateTimeField(null=True, blank=True)
	is_read = models.CharField(max_length=100, null=True, blank=True)
	views = models.PositiveIntegerField(default=0)
	likes = models.PositiveIntegerField(default=0)
	comments = models.PositiveIntegerField(default=0)
	is_visible = models.BooleanField(default=True)
	status = models.CharField(max_length=20, choices=Status.choices, default=Status.PUBLISHED, db_column="blog_status")
	updated_at = models.DateTimeField()

	class Meta:
		db_table = "post"
		managed = False
		ordering = ["-created_at", "-id"]

	def __str__(self):
		return self.title


class Comment(models.Model):
	id = models.AutoField(primary_key=True, db_column="comment_id")
	user = models.ForeignKey(User, models.CASCADE, db_column="user_id", related_name="comments")
	post = models.ForeignKey(Post, models.CASCADE, db_column="blog_id", related_name="comment_set")
	body = models.TextField(db_column="comment")
	is_visible = models.BooleanField(default=True)
	created_at = models.DateTimeField(null=True, blank=True)

	class Meta:
		db_table = "comment"
		managed = False
		ordering = ["created_at"]

	def __str__(self):
		return f"Comment by {self.user} on {self.post}"


class Like(models.Model):
	pk = models.CompositePrimaryKey("user", "post")
	user = models.ForeignKey(User, models.CASCADE, db_column="user_id")
	post = models.ForeignKey(Post, models.CASCADE, db_column="blog_id")
	liked_at = models.DateField(null=True, blank=True, db_column="like_date")

	class Meta:
		db_table = "likes"
		managed = False


class Subscription(models.Model):
	pk = models.CompositePrimaryKey("user", "editor")
	user = models.ForeignKey(User, models.CASCADE, db_column="user_id", related_name="subscriptions")
	editor = models.ForeignKey(User, models.CASCADE, db_column="editor_id", related_name="followers")
	subscribed_at = models.DateField(null=True, blank=True, db_column="subscription_date")

	class Meta:
		db_table = "subscription"
		managed = False


class Notification(models.Model):
	id = models.AutoField(primary_key=True, db_column="notification_id")
	user = models.ForeignKey(User, models.CASCADE, db_column="user_id", related_name="notifications")
	is_read = models.BooleanField(default=False)
	title = models.TextField(null=True, blank=True)
	link = models.CharField(max_length=300, null=True, blank=True)
	content = models.TextField(null=True, blank=True)
	actor = models.ForeignKey(
		User, models.SET_NULL, null=True, blank=True, db_column="actor_id", related_name="activity_notifications"
	)
	created_at = models.DateTimeField()

	class Meta:
		db_table = "notification"
		managed = False
		ordering = ["-created_at", "-id"]


class ContactMessage(models.Model):
	id = models.AutoField(primary_key=True, db_column="message_id")
	sender_name = models.CharField(max_length=200)
	sender_email = models.EmailField(max_length=250)
	subject = models.CharField(max_length=250)
	message = models.TextField()
	submitted_at = models.DateTimeField()
	is_resolved = models.BooleanField(default=False)

	class Meta:
		db_table = "contact_message"
		managed = False
		ordering = ["is_resolved", "-submitted_at"]


class LoginHistory(models.Model):
	id = models.AutoField(primary_key=True, db_column="login_id")
	user = models.ForeignKey(User, models.CASCADE, db_column="user_id", related_name="login_history")
	login_time = models.DateTimeField(null=True, blank=True)
	ip_address = models.CharField(max_length=45, null=True, blank=True)

	class Meta:
		db_table = "login"
		managed = False
		ordering = ["-login_time"]
