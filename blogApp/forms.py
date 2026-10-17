from django import forms

from .models import Category, Comment, ContactMessage, Post, User


class SignUpForm(forms.Form):
    username = forms.CharField(max_length=200)
    email = forms.EmailField(max_length=250)
    password = forms.CharField(min_length=8, widget=forms.PasswordInput)
    password_confirm = forms.CharField(widget=forms.PasswordInput, label="Confirm password")

    def clean_email(self):
        email = User.objects.normalize_email(self.cleaned_data["email"])
        if User.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError("An account with this email already exists.")
        return email

    def clean(self):
        cleaned_data = super().clean()
        if cleaned_data.get("password") != cleaned_data.get("password_confirm"):
            self.add_error("password_confirm", "The passwords do not match.")
        return cleaned_data

    def save(self):
        return User.objects.create_user(
            email=self.cleaned_data["email"],
            username=self.cleaned_data["username"],
            password=self.cleaned_data["password"],
            role=User.Role.USER,
            is_active=True,
        )


class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = ["title", "description", "body", "category", "status"]
        widgets = {
            "title": forms.TextInput(attrs={"placeholder": "A clear, memorable title"}),
            "description": forms.Textarea(attrs={"rows": 3, "placeholder": "A short introduction"}),
            "body": forms.Textarea(attrs={"rows": 16, "placeholder": "Write your story"}),
        }


class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = ["body"]
        widgets = {"body": forms.Textarea(attrs={"rows": 3, "placeholder": "Add to the conversation"})}


class ContactForm(forms.ModelForm):
    class Meta:
        model = ContactMessage
        fields = ["sender_name", "sender_email", "subject", "message"]
        widgets = {"message": forms.Textarea(attrs={"rows": 6})}


class CategoryForm(forms.ModelForm):
    class Meta:
        model = Category
        fields = ["name"]