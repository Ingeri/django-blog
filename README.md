# Fieldnotes Django blog

A Django publishing site backed by the tables in `db/blog_db.sql`. The application maps Django models onto the existing MySQL tables, so the imported posts, accounts, comments, likes, follows, notifications, contact messages, and sign-in history remain the source of truth.

## Set up MySQL

Create the database and import the dump:

```sql
CREATE DATABASE blog_db CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

```sh
mysql -u your_mysql_user -p blog_db < db/blog_db.sql
```

Install dependencies and configure the connection. Copy `.env.example` to `.env` and replace the database user and password with your MySQL credentials:

```sh
uv pip install -r requirements.txt
cp .env.example .env
```

Apply Django's built-in session and authentication migrations, then start the site:

```sh
uv run --env-file .env python manage.py migrate
uv run --env-file .env python manage.py runserver
```

Always pass `--env-file .env` when using `uv run`; otherwise Django defaults to the local SQLite file. The blog models map to existing SQL tables and are intentionally unmanaged, so migrations do not create `post`, `users`, or the other tables in SQLite. Import `db/blog_db.sql` into MySQL before starting the site.

The application uses the `users` table for authentication. Existing `pbkdf2$...` hashes are verified by a compatibility hasher and upgraded to Django's current PBKDF2 format when the user next signs in. New signups are readers. An administrator can assign the `editor` role in **Manage → People**; editors can draft and publish stories in **Studio**.

For a blank SQLite-only development database, leave `DB_ENGINE` unset and the project uses `db.sqlite3`. The exported blog content is available only after importing the SQL dump into MySQL.

## Roles

- **Reader:** browse and search published stories, follow editors, appreciate posts, comment, and read notifications.
- **Editor:** publish or draft stories, view engagement, and hide or restore comments on their own stories.
- **Administrator:** manage account roles and access, publish status and visibility, comments, contact messages, sign-in history, and categories.

Role checks are enforced in Django views. New public registrations can only create reader accounts.

## Configuration

`DJANGO_SECRET_KEY`, `DJANGO_DEBUG`, and `DJANGO_ALLOWED_HOSTS` configure Django. Set `DB_ENGINE=mysql`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, and `DB_PORT` for the imported MySQL database. Do not commit `.env` or production credentials. Use `.env.example` as a starting point.
