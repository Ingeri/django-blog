"""Import the MySQL phpMyAdmin dump into the project's SQLite database."""

import re
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "db" / "blog_db.sql"
TARGET = ROOT / "db" / "blog.sqlite3"

PRIMARY_KEYS = {
    "categories": ("category_id",),
    "comment": ("comment_id",),
    "contact_message": ("message_id",),
    "likes": ("user_id", "blog_id"),
    "login": ("login_id",),
    "notification": ("notification_id",),
    "post": ("blog_id",),
    "subscription": ("user_id", "editor_id"),
    "users": ("user_id",),
}


def statements(sql):
    """Yield semicolon-delimited statements while respecting quoted strings."""
    start = 0
    quoted = False
    escaped = False
    for index, char in enumerate(sql):
        if escaped:
            escaped = False
        elif char == "\\" and quoted:
            escaped = True
        elif char == "'":
            quoted = not quoted
        elif char == ";" and not quoted:
            yield sql[start:index + 1].strip()
            start = index + 1


def sqlite_create(statement):
    match = re.match(r"CREATE TABLE `([^`]+)` \((.*)\)\s*(?:ENGINE=.*)?;\s*$", statement, re.S)
    if not match:
        return None
    table, body = match.groups()
    primary = PRIMARY_KEYS[table]
    definitions = []
    for line in body.splitlines():
        line = line.strip().rstrip(",")
        if not line:
            continue
        column_match = re.match(r"`([^`]+)`\s+(.+)$", line)
        if not column_match:
            continue
        name, definition = column_match.groups()
        definition = re.sub(r"\bint\b", "INTEGER", definition, flags=re.I)
        definition = re.sub(r"tinyint\(1\)", "INTEGER", definition, flags=re.I)
        definition = re.sub(r"varchar\(\d+\)", "TEXT", definition, flags=re.I)
        definition = re.sub(r"\b(?:timestamp|datetime|date)\b", "TEXT", definition, flags=re.I)
        definition = re.sub(r"\s+ON UPDATE CURRENT_TIMESTAMP", "", definition, flags=re.I)
        if len(primary) == 1 and name == primary[0]:
            definition += " PRIMARY KEY"
        definitions.append(f'"{name}" {definition}')
    if len(primary) > 1:
        definitions.append("PRIMARY KEY (" + ", ".join(f'"{name}"' for name in primary) + ")")
    if table == "post":
        definitions.append('UNIQUE ("slug")')
    if table == "users":
        definitions.append('UNIQUE ("email")')
    return f'CREATE TABLE "{table}" ({", ".join(definitions)});'


def sqlite_insert(statement):
    statement = re.sub(r"\\'", "''", statement)
    statement = statement.replace("\\r", "\r").replace("\\n", "\n").replace("\\t", "\t")
    return statement.replace("`", '"')


def main():
    if not SOURCE.exists():
        raise SystemExit(f"SQL dump not found: {SOURCE}")
    TARGET.parent.mkdir(parents=True, exist_ok=True)
    connection = sqlite3.connect(TARGET)
    try:
        existing = {row[0] for row in connection.execute("SELECT name FROM sqlite_master WHERE type='table'")}
        imported_tables = set(PRIMARY_KEYS)
        if imported_tables & existing:
            raise SystemExit(f"{TARGET} already contains imported blog tables; refusing to overwrite them")
        connection.execute("PRAGMA foreign_keys = ON")
        dump = SOURCE.read_text(encoding="utf-8")
        dump = re.sub(r"/\*.*?\*/", "", dump, flags=re.S)
        dump = re.sub(r"(?m)^\s*--.*$", "", dump)
        for statement in statements(dump):
            if statement.startswith("CREATE TABLE"):
                connection.execute(sqlite_create(statement))
            elif statement.startswith("INSERT INTO"):
                connection.execute(sqlite_insert(statement))
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()
    print(f"Imported {len(PRIMARY_KEYS)} tables from {SOURCE.name} into {TARGET.name}")


if __name__ == "__main__":
    main()
