# 🚌 TripSync - Smart Transportation Tracking

A comprehensive Flutter application for bus tracking and transportation management with real-time features, user authentication, and admin management capabilities.

## ✨ Features

### 🔐 **Authentication System**
- **Role-based Login** - Students, Drivers, and Admins
- **Secure Registration** - JWT token-based authentication
- **Real API Integration** - PostgreSQL database backend
- **Personalized Dashboards** - User-specific welcome screens

### 👨‍🎓 **Student Features**
- **Bus Tracking** - Real-time location tracking
- **Route Information** - Complete bus route details
- **Student Registration** - ID-based registration system
- **Profile Management** - Personal information management

### 🚌 **Driver Features**
- **Location Sharing** - Real-time GPS tracking
- **Route Management** - Assigned route information
- **Driver Registration** - License and vehicle registration
- **Dashboard** - Driver-specific interface

### 👑 **Admin Features**
- **Student Management** - View and manage all students
- **Driver Management** - View and manage all drivers
- **User Analytics** - Complete user overview
- **Real-time Data** - Live database integration

## 🛠️ Tech Stack

### **Frontend (Flutter)**
- **Framework:** Flutter 3.x
- **Language:** Dart
- **Maps:** Flutter Map with OpenStreetMap
- **HTTP:** http package for API calls
- **State Management:** Provider pattern
- **UI:** Material Design 3

### **Backend (Node.js)**
- **Framework:** Express.js
- **Database:** PostgreSQL
- **Authentication:** JWT + bcrypt
- **Validation:** Joi
- **Security:** Helmet, CORS, Rate limiting

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (3.0+)
- Node.js (16+)
- PostgreSQL (12+)
- Android Studio / VS Code

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/Amal-Babu07/tripsync.git
   cd tripsync
   ```

2. **Setup Flutter App**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Setup Backend**
   ```bash
   cd tripsync-backend
   npm install
   npm run dev
   ```

4. **Database Setup**
   ```bash
   # Create PostgreSQL database
   createdb tripsync_db
   
   # Run migrations
   npm run migrate
   
   # Seed initial data
   npm run seed
   ```

## 📱 App Structure

```
lib/
├── main.dart                 # Main app entry point
├── services/
│   └── api_service.dart     # API service layer
└── reports_analytics.dart   # Analytics module

tripsync-backend/
├── src/
│   ├── config/             # Database configuration
│   ├── models/             # Data models
│   ├── routes/             # API routes
│   ├── middleware/         # Authentication & validation
│   └── migrations/         # Database migrations
```

## 🔑 Default Admin Credentials

- **Admin 1:** `amal@admin.tripsync.com` / `admin123`
- **Admin 2:** `aleena@admin.tripsync.com` / `admin123`

## 🗄️ Database Schema

### **Users Table**
- `id` - Primary key
- `email` - Unique email address
- `password_hash` - Encrypted password
- `first_name` - User's first name
- `last_name` - User's last name
- `phone_number` - Contact number
- `role` - User role (student/driver/admin)
- `student_id` - Student ID (for students)
- `license_number` - License number (for drivers)
- `vehicle_number` - Vehicle registration (for drivers)

## 🌐 API Endpoints

### **Authentication**
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/verify` - Token verification

### **User Management**
- `GET /api/users` - Get all users (admin)
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile
- `DELETE /api/users/profile` - Delete account

## 🎯 Key Features Implemented

### **✅ Complete Authentication Flow**
- Registration with role-specific fields
- Login with JWT token generation
- Role-based navigation and access control

### **✅ Real Database Integration**
- PostgreSQL with proper migrations
- User management with CRUD operations
- Secure password hashing with bcrypt

### **✅ Admin Management System**
- View all registered students
- View all registered drivers
- Real-time data updates
- User filtering and management

### **✅ Responsive UI/UX**
- Modern Material Design interface
- Loading states and error handling
- Form validation and user feedback
- Smooth animations and transitions

## 🔧 Configuration

### **Network Configuration**
Update the API base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

### **Database Configuration**
Update database settings in `tripsync-backend/src/config/database.js`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Amal Babu**
- GitHub: [@Amal-Babu07](https://github.com/Amal-Babu07)
- Email: amal@admin.tripsync.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenStreetMap for map data
- PostgreSQL for robust database support
- Express.js for backend framework

---

**Built with ❤️ using Flutter & Node.js**
