#!/bin/bash

# TripSync Backend Setup Script
# This script helps set up the backend environment

echo "🚀 TripSync Backend Setup"
echo "========================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js v16 or higher."
    exit 1
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "⚠️  PostgreSQL is not installed. Please install PostgreSQL v12 or higher."
    echo "   You can also use Docker to run PostgreSQL."
fi

echo "✅ Node.js version: $(node --version)"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit the .env file with your database credentials and other settings."
    echo "   Database settings:"
    echo "   - DB_HOST=localhost"
    echo "   - DB_PORT=5432"
    echo "   - DB_NAME=tripsync_db"
    echo "   - DB_USER=postgres"
    echo "   - DB_PASSWORD=your_password_here"
    echo ""
    echo "   JWT settings:"
    echo "   - JWT_SECRET=your_super_secret_jwt_key_here"
    echo ""
    read -p "Press Enter to continue after editing .env file..."
fi

# Check if database exists and is accessible
echo "🗄️  Checking database connection..."
if npm run migrate > /dev/null 2>&1; then
    echo "✅ Database connection successful"
    echo "✅ Database migrations completed"
else
    echo "❌ Database connection failed. Please check your database settings in .env file."
    echo "   Make sure PostgreSQL is running and the database exists."
    echo "   You can create the database with: createdb tripsync_db"
    exit 1
fi

# Seed the database
echo "🌱 Seeding database with sample data..."
if npm run seed; then
    echo "✅ Database seeded successfully"
else
    echo "⚠️  Database seeding failed, but this is not critical."
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Start the development server: npm run dev"
echo "   2. Test the API: curl http://localhost:3000/health"
echo "   3. View the API documentation in README.md"
echo ""
echo "🔗 Useful URLs:"
echo "   - Health check: http://localhost:3000/health"
echo "   - API base URL: http://localhost:3000/api"
echo ""
echo "📚 Sample users (if seeded):"
echo "   - john.doe@example.com (password: password123)"
echo "   - jane.smith@example.com (password: password123)"
echo "   - mike.johnson@example.com (password: password123)"
