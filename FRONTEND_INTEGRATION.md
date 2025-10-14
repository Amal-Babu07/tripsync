# TripSync Frontend Integration Guide

This guide explains how to connect your Flutter frontend to the TripSync backend API.

## 🚀 Quick Start

### 1. Start the Backend Server

First, make sure your backend is running:

```bash
cd tripsync-backend
npm run dev
```

The backend should be running on `http://localhost:3000`

### 2. Switch to TripSync App

To use the new TripSync app instead of the bus tracking app, update your `lib/main.dart`:

```dart
// Replace the content of lib/main.dart with:
export 'main_tripsync.dart';
```

Or simply rename the files:
- Rename `lib/main.dart` to `lib/main_bus.dart` (backup)
- Rename `lib/main_tripsync.dart` to `lib/main.dart`

### 3. Run the Flutter App

```bash
flutter run
```

## 📱 App Features

### Authentication
- **Login**: Email and password authentication
- **Register**: Create new user accounts
- **Auto-login**: Remembers user session with JWT tokens

### Trip Management
- **View Trips**: See all your trips organized by status (Upcoming, Ongoing, Past)
- **Create Trips**: Add new trips with title, destination, dates, description, and budget
- **Trip Details**: View full trip information and participants
- **Edit/Delete**: Modify or remove trips (creator only)

### Collaboration
- **Add Participants**: Invite users to trips by email
- **Remove Participants**: Remove users from trips (creator only)
- **User Search**: Find users by email address

### Profile Management
- **View Profile**: See your account information
- **Edit Profile**: Update name and phone number
- **Logout**: Secure logout with token cleanup

## 🔧 Configuration

### API Base URL

Update the base URL in `lib/services/api_service.dart` based on your environment:

```dart
// For different environments:
static const String baseUrl = 'http://localhost:3000/api';        // Local development
static const String baseUrl = 'http://10.0.2.2:3000/api';        // Android Emulator
static const String baseUrl = 'http://YOUR_LOCAL_IP:3000/api';    // Real device
```

### Backend Environment

Make sure your backend `.env` file is configured:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tripsync_db
DB_USER=postgres
DB_PASSWORD=2004
JWT_SECRET=https://dev-drhwuf0sda4d8kxx.us.auth0.com/api/v2/
```

## 📁 Project Structure

```
lib/
├── main_tripsync.dart          # New TripSync app entry point
├── models/
│   ├── user.dart               # User data model
│   └── trip.dart               # Trip and participant models
├── providers/
│   ├── auth_provider.dart      # Authentication state management
│   └── trip_provider.dart      # Trip state management
├── screens/
│   ├── login_screen.dart       # Login interface
│   ├── register_screen.dart    # Registration interface
│   ├── home_screen.dart        # Main dashboard
│   ├── create_trip_screen.dart # Trip creation form
│   ├── trip_detail_screen.dart # Trip details and management
│   └── profile_screen.dart     # User profile management
└── services/
    └── api_service.dart        # Updated API client
```

## 🔄 API Integration

### Authentication Flow

1. **Login/Register**: User enters credentials
2. **Token Storage**: JWT token saved to SharedPreferences
3. **Auto-Authentication**: Token verified on app start
4. **API Requests**: Token included in Authorization header

### Data Flow

1. **Providers**: Manage app state using ChangeNotifier
2. **API Service**: Handles HTTP requests to backend
3. **Models**: Type-safe data structures
4. **UI Updates**: Automatic updates via Provider pattern

## 🧪 Testing the Integration

### 1. Test Authentication

1. Start the backend server
2. Run the Flutter app
3. Try registering a new account
4. Login with the created account
5. Verify profile information

### 2. Test Trip Management

1. Create a new trip with all details
2. View the trip in the trips list
3. Open trip details
4. Try editing the trip (if you're the creator)

### 3. Test Collaboration

1. Create a trip
2. Add a participant by email (use sample users from backend seed)
3. Verify participant appears in trip details

### Sample Users (if backend is seeded)

```
Email: john.doe@example.com
Password: password123

Email: jane.smith@example.com  
Password: password123

Email: mike.johnson@example.com
Password: password123
```

## 🐛 Troubleshooting

### Connection Issues

1. **Backend not running**: Make sure `npm run dev` is running
2. **Wrong URL**: Check API base URL in `api_service.dart`
3. **CORS issues**: Backend already configured for CORS
4. **Network permissions**: Android may need network permissions

### Authentication Issues

1. **Invalid credentials**: Check email/password format
2. **Token expired**: Tokens expire after 7 days by default
3. **JWT secret**: Make sure backend JWT_SECRET is set

### Database Issues

1. **Connection failed**: Check PostgreSQL is running
2. **Tables missing**: Run `npm run migrate` in backend
3. **No data**: Run `npm run seed` for sample data

## 📚 API Endpoints Reference

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/verify` - Verify token

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile
- `GET /api/users/search` - Search user by email

### Trips
- `GET /api/trips` - Get user's trips
- `POST /api/trips` - Create new trip
- `GET /api/trips/:id` - Get trip details
- `PUT /api/trips/:id` - Update trip
- `DELETE /api/trips/:id` - Delete trip
- `POST /api/trips/:id/participants` - Add participant
- `DELETE /api/trips/:id/participants/:userId` - Remove participant

## 🎯 Next Steps

1. **Test the integration** with your backend
2. **Customize the UI** to match your design preferences
3. **Add more features** like trip itineraries, expenses, etc.
4. **Deploy** both frontend and backend for production use

## 💡 Tips

- Use Flutter DevTools for debugging
- Check backend logs for API errors
- Test on both emulator and real device
- Use the health check endpoint to verify backend connectivity
