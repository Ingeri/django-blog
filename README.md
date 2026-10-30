# Fieldnotes Django blog

A Django publishing site backed by the tables in `db/blog_db.sql`. The app uses SQLite and imports the existing MySQL phpMyAdmin dump into `db/blog.sqlite3`.

## Set up SQLite

Create the SQLite database from the included dump:

```sh
blog/bin/python db/import_sqlite.py
```

The importer preserves the existing users, posts, categories, comments, likes, follows, notifications, contact messages, and sign-in history. It adds those tables to the SQLite file without replacing existing Django migration tables. It refuses to run again if the dump's tables are already present.

Install dependencies, apply Django's built-in migrations, and start the site:

```sh
blog/bin/python -m pip install -r requirements.txt
blog/bin/python manage.py migrate
blog/bin/python manage.py runserver
```

The database defaults to `db/blog.sqlite3`; set `DB_NAME` to use another SQLite file. The blog models map to the imported tables and are intentionally unmanaged, so Django migrations create its authentication and session tables while `db/import_sqlite.py` imports the blog data.

The application uses the `users` table for authentication. Existing `pbkdf2$...` hashes are verified by a compatibility hasher and upgraded to Django's current PBKDF2 format when the user next signs in. New signups are readers. An administrator can assign the `editor` role in **Manage → People**; editors can draft and publish stories in **Studio**.

## Roles

- **Reader:** browse and search published stories, follow editors, appreciate posts, comment, and read notifications.
- **Editor:** publish or draft stories, view engagement, and hide or restore comments on their own stories.
- **Administrator:** manage account roles and access, publish status and visibility, comments, contact messages, sign-in history, and categories.

Role checks are enforced in Django views. New public registrations can only create reader accounts.

## Configuration

`DJANGO_SECRET_KEY`, `DJANGO_DEBUG`, and `DJANGO_ALLOWED_HOSTS` configure Django. `DB_NAME` optionally selects a SQLite database path. Do not commit `.env` or production credentials. Use `.env.example` as a starting point.
