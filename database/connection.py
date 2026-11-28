import sqlite3
from pathlib import Path

# تحديد مكان قاعدة البيانات
DATABASE_PATH = Path(__file__).resolve().parent / "morning_azkar.db"


def get_connection():
    """Create and return a database connection."""

    connection = sqlite3.connect(DATABASE_PATH, timeout=10)

    # Return rows as dictionary-like objects
    connection.row_factory = sqlite3.Row

    # Enable foreign key relationships
    connection.execute("PRAGMA foreign_keys = ON")

    return connection


def initialize_database():
    """Create all database tables."""

    schema_path = Path(__file__).with_name("schema.sql")

    connection = get_connection()

    try:
        schema = schema_path.read_text(encoding="utf-8")

        connection.executescript(schema)
        connection.commit()

        print("Database initialized successfully!")

    except Exception:
        connection.rollback()
        raise

    finally:
        connection.close()


if __name__ == "__main__":
    initialize_database()
