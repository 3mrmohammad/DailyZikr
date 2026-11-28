-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL COLLATE NOCASE UNIQUE,
    password_hash TEXT NOT NULL,
         TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Azkar Table
CREATE TABLE IF NOT EXISTS azkar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    target_count INTEGER NOT NULL CHECK(target_count > 0),
    reward_points INTEGER NOT NULL DEFAULT 0
        CHECK(reward_points >= 0),
    source TEXT
);

-- 3. Daily Azkar Progress
CREATE TABLE IF NOT EXISTS daily_azkar_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    azkar_id INTEGER NOT NULL,
    activity_date TEXT NOT NULL,
    completed_count INTEGER NOT NULL DEFAULT 0
        CHECK(completed_count >= 0),
    rewarded INTEGER NOT NULL DEFAULT 0
        CHECK(rewarded IN (0, 1)),

    FOREIGN KEY(user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY(azkar_id) REFERENCES azkar(id),

    UNIQUE(user_id, azkar_id, activity_date)
);

-- 4. Daily Sessions
CREATE TABLE IF NOT EXISTS daily_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    activity_date TEXT NOT NULL,
    completed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    UNIQUE(user_id, activity_date)
);

-- 5. User Streaks
CREATE TABLE IF NOT EXISTS user_streaks (
    user_id INTEGER PRIMARY KEY,
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    last_completed_date TEXT,

    FOREIGN KEY(user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

-- 6. Points Transactions
CREATE TABLE IF NOT EXISTS points_transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    points INTEGER NOT NULL CHECK(points > 0),
    reason TEXT NOT NULL,
    reference_key TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    UNIQUE(user_id, reference_key)
);

-- 7. Tasbeeh Types
CREATE TABLE IF NOT EXISTS tasbeeh_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    target_count INTEGER NOT NULL CHECK(target_count > 0),
    reward_points INTEGER NOT NULL DEFAULT 0
        CHECK(reward_points >= 0)
);

-- 8. Tasbeeh Progress
CREATE TABLE IF NOT EXISTS tasbeeh_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    tasbeeh_type_id INTEGER NOT NULL,
    activity_date TEXT NOT NULL,
    count INTEGER NOT NULL DEFAULT 0 CHECK(count >= 0),
    points_awarded INTEGER NOT NULL DEFAULT 0
        CHECK(points_awarded >= 0),

    FOREIGN KEY(user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY(tasbeeh_type_id) REFERENCES tasbeeh_types(id),

    UNIQUE(user_id, tasbeeh_type_id, activity_date)
);

-- Indexes for faster leaderboard queries
CREATE INDEX IF NOT EXISTS idx_points_user
ON points_transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_points_date
ON points_transactions(created_at);
