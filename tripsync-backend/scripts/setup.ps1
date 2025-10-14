# TripSync Backend Setup Script for Windows PowerShell
# This script helps set up the backend environment on Windows

Write-Host "🚀 TripSync Backend Setup" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js is not installed. Please install Node.js v16 or higher." -ForegroundColor Red
    exit 1
}

# Check if PostgreSQL is installed
try {
    $pgVersion = psql --version
    Write-Host "✅ PostgreSQL found: $pgVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️  PostgreSQL is not installed. Please install PostgreSQL v12 or higher." -ForegroundColor Yellow
    Write-Host "   You can also use Docker to run PostgreSQL." -ForegroundColor Yellow
}

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Blue
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creating .env file from template..." -ForegroundColor Blue
    Copy-Item ".env.example" ".env"
    Write-Host "⚠️  Please edit the .env file with your database credentials and other settings." -ForegroundColor Yellow
    Write-Host "   Database settings:" -ForegroundColor Yellow
    Write-Host "   - DB_HOST=localhost" -ForegroundColor Yellow
    Write-Host "   - DB_PORT=5432" -ForegroundColor Yellow
    Write-Host "   - DB_NAME=tripsync_db" -ForegroundColor Yellow
    Write-Host "   - DB_USER=postgres" -ForegroundColor Yellow
    Write-Host "   - DB_PASSWORD=your_password_here" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   JWT settings:" -ForegroundColor Yellow
    Write-Host "   - JWT_SECRET=your_super_secret_jwt_key_here" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to continue after editing .env file"
}

# Check if database exists and is accessible
Write-Host "🗄️  Checking database connection..." -ForegroundColor Blue
$migrateOutput = npm run migrate 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Database connection successful" -ForegroundColor Green
    Write-Host "✅ Database migrations completed" -ForegroundColor Green
} else {
    Write-Host "❌ Database connection failed. Please check your database settings in .env file." -ForegroundColor Red
    Write-Host "   Make sure PostgreSQL is running and the database exists." -ForegroundColor Red
    Write-Host "   You can create the database with: createdb tripsync_db" -ForegroundColor Red
    exit 1
}

# Seed the database
Write-Host "🌱 Seeding database with sample data..." -ForegroundColor Blue
$seedOutput = npm run seed 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Database seeded successfully" -ForegroundColor Green
} else {
    Write-Host "⚠️  Database seeding failed, but this is not critical." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Blue
Write-Host "   1. Start the development server: npm run dev" -ForegroundColor White
Write-Host "   2. Test the API: Invoke-WebRequest http://localhost:3000/health" -ForegroundColor White
Write-Host "   3. View the API documentation in README.md" -ForegroundColor White
Write-Host ""
Write-Host "🔗 Useful URLs:" -ForegroundColor Blue
Write-Host "   - Health check: http://localhost:3000/health" -ForegroundColor White
Write-Host "   - API base URL: http://localhost:3000/api" -ForegroundColor White
Write-Host ""
Write-Host "📚 Sample users (if seeded):" -ForegroundColor Blue
Write-Host "   - john.doe@example.com (password: password123)" -ForegroundColor White
Write-Host "   - jane.smith@example.com (password: password123)" -ForegroundColor White
Write-Host "   - mike.johnson@example.com (password: password123)" -ForegroundColor White
