"""
URL configuration for config project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from blogApp import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),
    path('contact/', views.contact, name='contact'),
    path('login/', views.sign_in, name='login'),
    path('logout/', views.sign_out, name='logout'),
    path('register/', views.sign_up, name='register'),
    path('notifications/', views.notifications, name='notifications'),
    path('posts/<slug:slug>/', views.post_detail, name='post_detail'),
    path('posts/<slug:slug>/comment/', views.add_comment, name='add_comment'),
    path('posts/<slug:slug>/like/', views.toggle_like, name='toggle_like'),
    path('editors/<int:user_id>/follow/', views.toggle_follow, name='toggle_follow'),
    path('editor/', views.editor_dashboard, name='editor_dashboard'),
    path('editor/posts/new/', views.edit_post, name='new_post'),
    path('editor/posts/<int:post_id>/edit/', views.edit_post, name='edit_post'),
    path('editor/comments/<int:comment_id>/visibility/', views.moderate_editor_comment, name='moderate_editor_comment'),
    path('manage/', views.management_dashboard, name='manage'),
]
