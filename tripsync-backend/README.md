# TripSync Backend API

A robust Node.js backend API for the TripSync travel planning application, built with Express.js and PostgreSQL.

## 🚀 Features

- **User Authentication**: JWT-based authentication with secure password hashing
- **Trip Management**: Create, read, update, and delete trips
- **User Management**: User registration, login, and profile management
- **Trip Collaboration**: Add/remove participants to trips
- **Security**: Rate limiting, CORS protection, input validation, and security headers
- **Database**: PostgreSQL with automated migrations and seeding
- **Validation**: Comprehensive input validation using Joi
- **Error Handling**: Centralized error handling with detailed error messages

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

- **Node.js** (v16 or higher)
- **npm** or **yarn**
- **PostgreSQL** (v12 or higher)

## 🛠️ Installation

1. **Clone the repository** (if not already done):
   ```bash
   cd tripsync-backend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```
   
   Edit the `.env` file with your configuration:
   ```env
   # Database Configuration
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=tripsync_db
   DB_USER=postgres
   DB_PASSWORD=your_password_here
   
   # Server Configuration
   PORT=3000
   NODE_ENV=development
   
   # JWT Configuration
   JWT_SECRET=your_super_secret_jwt_key_here
   JWT_EXPIRES_IN=7d
   
   # CORS Configuration
   ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
   ```

## 🗄️ Database Setup

1. **Create PostgreSQL database**:
   ```sql
   CREATE DATABASE tripsync_db;
   ```

2. **Run database migrations**:
   ```bash
   npm run migrate
   ```

3. **Seed the database** (optional - adds sample data):
   ```bash
   npm run seed
   ```

## 🏃‍♂️ Running the Application

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on `http://localhost:3000` (or the port specified in your `.env` file).

## 📚 API Documentation

### Base URL
```
http://localhost:3000/api
```

### Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "+1-555-0123"
}
```

#### Login User
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Verify Token
```http
GET /api/auth/verify
Authorization: Bearer <jwt_token>
```

### User Endpoints

#### Get User Profile
```http
GET /api/users/profile
Authorization: Bearer <jwt_token>
```

#### Update User Profile
```http
PUT /api/users/profile
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "+1-555-0123"
}
```

#### Search User by Email
```http
GET /api/users/search?email=user@example.com
Authorization: Bearer <jwt_token>
```

### Trip Endpoints

#### Get All User Trips
```http
GET /api/trips
Authorization: Bearer <jwt_token>
```

#### Get Specific Trip
```http
GET /api/trips/:id
Authorization: Bearer <jwt_token>
```

#### Create New Trip
```http
POST /api/trips
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "title": "Summer Vacation",
  "description": "A relaxing beach vacation",
  "destination": "Bali, Indonesia",
  "startDate": "2024-07-15",
  "endDate": "2024-07-25",
  "budget": 2500.00
}
```

#### Update Trip
```http
PUT /api/trips/:id
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "title": "Updated Trip Title",
  "budget": 3000.00
}
```

#### Delete Trip
```http
DELETE /api/trips/:id
Authorization: Bearer <jwt_token>
```

#### Add Participant to Trip
```http
POST /api/trips/:id/participants
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "userId": 2
}
```

#### Remove Participant from Trip
```http
DELETE /api/trips/:id/participants/:userId
Authorization: Bearer <jwt_token>
```

### Health Check
```http
GET /health
```

## 🗂️ Project Structure

```
tripsync-backend/
├── src/
│   ├── config/
│   │   └── database.js          # Database connection configuration
│   ├── middleware/
│   │   ├── auth.js              # JWT authentication middleware
│   │   └── validation.js        # Request validation middleware
│   ├── models/
│   │   ├── User.js              # User model with database operations
│   │   └── Trip.js              # Trip model with database operations
│   ├── routes/
│   │   ├── auth.js              # Authentication routes
│   │   ├── users.js             # User management routes
│   │   └── trips.js             # Trip management routes
│   ├── migrations/
│   │   ├── 001_create_users_table.sql
│   │   ├── 002_create_trips_table.sql
│   │   ├── 003_create_trip_participants_table.sql
│   │   └── migrate.js           # Migration runner
│   ├── seeds/
│   │   └── seed.js              # Database seeding script
│   └── server.js                # Main application entry point
├── .env.example                 # Environment variables template
├── .gitignore                   # Git ignore rules
├── package.json                 # Project dependencies and scripts
└── README.md                    # Project documentation
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Password Hashing**: Bcrypt with salt rounds for secure password storage
- **Rate Limiting**: Prevents brute force attacks
- **CORS Protection**: Configurable cross-origin resource sharing
- **Input Validation**: Comprehensive validation using Joi
- **Security Headers**: Helmet.js for security headers
- **SQL Injection Protection**: Parameterized queries

## 🧪 Sample Data

If you run the seed script, the following sample data will be created:

### Users
- **John Doe** (john.doe@example.com) - Password: password123
- **Jane Smith** (jane.smith@example.com) - Password: password123
- **Mike Johnson** (mike.johnson@example.com) - Password: password123

### Trips
- **Summer Vacation in Bali** - Created by John Doe, Jane Smith as participant
- **European Adventure** - Created by Jane Smith, Mike Johnson as participant
- **Weekend Getaway to Mountains** - Created by Mike Johnson

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**:
   - Ensure PostgreSQL is running
   - Check database credentials in `.env` file
   - Verify database exists

2. **Port Already in Use**:
   - Change the PORT in `.env` file
   - Kill the process using the port: `lsof -ti:3000 | xargs kill -9`

3. **JWT Token Issues**:
   - Ensure JWT_SECRET is set in `.env` file
   - Check token expiration settings

### Logs
The application uses Morgan for HTTP request logging in development mode. Check the console for detailed error messages.

## 🚀 Deployment

For production deployment:

1. Set `NODE_ENV=production` in your environment
2. Use a process manager like PM2
3. Set up a reverse proxy (nginx)
4. Use environment variables for sensitive configuration
5. Set up database backups
6. Configure monitoring and logging

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For support or questions, please create an issue in the repository.
