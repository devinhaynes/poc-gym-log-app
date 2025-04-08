-- schema.sql

-- ===============================
-- Users
-- ===============================
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===============================
-- Products (Smart Mirrors, Wearables, etc.)
-- ===============================
CREATE TABLE products (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('smart_mirror', 'heart_monitor', 'smart_watch', 'other')),
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===============================
-- User-Product Relationships
-- ===============================
CREATE TABLE user_products (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  registered_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, product_id)
);

-- ===============================
-- Workouts (Sessions)
-- ===============================
CREATE TABLE workouts (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  notes TEXT,
  tags TEXT[],
  total_duration INT,
  total_weight_lifted INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===============================
-- Exercises within Workouts
-- ===============================
CREATE TABLE exercises (
  id UUID PRIMARY KEY,
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  muscle_group TEXT,
  is_cardio BOOLEAN DEFAULT FALSE
);

-- ===============================
-- Sets within Exercises
-- ===============================
CREATE TABLE exercise_sets (
  id UUID PRIMARY KEY,
  exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
  set_number INT NOT NULL,
  reps INT,
  weight DECIMAL,
  duration INT,
  rpe INT
);
