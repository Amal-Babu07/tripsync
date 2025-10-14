-- This file is used by Docker to initialize the database
-- It will be executed when the PostgreSQL container starts for the first time

-- Create the database if it doesn't exist
-- Note: This is handled by the POSTGRES_DB environment variable in docker-compose.yml

-- You can add any additional database initialization here
-- For example, creating additional users, setting permissions, etc.

-- The main database schema will be created by running the migrations
-- after the container starts up
