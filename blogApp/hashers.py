from django.contrib.auth.hashers import PBKDF2PasswordHasher


class LegacyPBKDF2PasswordHasher(PBKDF2PasswordHasher):
    algorithm = "pbkdf2"