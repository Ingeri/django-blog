from django.apps import AppConfig


class BlogappConfig(AppConfig):
    name = 'blogApp'

    def ready(self):
        from django.contrib.auth.signals import user_logged_in

        user_logged_in.disconnect(dispatch_uid="update_last_login")
