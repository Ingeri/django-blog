from django.contrib.auth.hashers import check_password, identify_hasher, make_password
from django.contrib.auth.signals import user_logged_in
from django.template.loader import get_template
from django.test import SimpleTestCase
from unittest.mock import patch

from .hashers import LegacyPBKDF2PasswordHasher
from .models import Post, User


class LegacyPasswordTests(SimpleTestCase):
	def test_legacy_hash_verifies_and_upgrades(self):
		password = "fieldnotes-test-password"
		legacy_hash = LegacyPBKDF2PasswordHasher().encode(
			password,
			"legacy-salt",
			iterations=120000,
		)
		upgraded_hashes = []

		self.assertEqual(identify_hasher(legacy_hash).algorithm, "pbkdf2")
		self.assertTrue(check_password(password, legacy_hash, setter=lambda raw: upgraded_hashes.append(make_password(raw))))
		self.assertEqual(identify_hasher(upgraded_hashes[0]).algorithm, "pbkdf2_sha256")


class RoleTests(SimpleTestCase):
	def test_only_admins_are_staff(self):
		for role, expected in (
			(User.Role.ADMIN, True),
			(User.Role.EDITOR, False),
			(User.Role.USER, False),
		):
			with self.subTest(role=role):
				self.assertEqual(User(role=role).is_staff, expected)
				self.assertEqual(User(role=role).is_superuser, expected)

	def test_login_signal_does_not_write_missing_last_login_column(self):
		user = User(role=User.Role.USER)
		with patch.object(user, "save") as save:
			user_logged_in.send(sender=User, user=user, request=None)
		save.assert_not_called()


class PostStatusTests(SimpleTestCase):
	def test_imported_live_status_is_the_published_status(self):
		self.assertEqual(Post.Status.PUBLISHED, "live")


class TemplateTests(SimpleTestCase):
	def test_application_templates_compile(self):
		templates = (
			"blogApp/base.html",
			"blogApp/home.html",
			"blogApp/post_detail.html",
			"blogApp/auth_form.html",
			"blogApp/contact.html",
			"blogApp/notifications.html",
			"blogApp/editor_dashboard.html",
			"blogApp/post_form.html",
			"blogApp/management_dashboard.html",
		)
		for template in templates:
			with self.subTest(template=template):
				get_template(template)
