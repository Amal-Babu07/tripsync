const express = require('express');
const router = express.Router();
const User = require('../models/User');
const { generateToken } = require('../middleware/auth');
const { validateRequest, userRegistrationSchema, userLoginSchema } = require('../middleware/validation');

// ADMIN POLICY: Only 2 existing admin accounts are allowed in the system.
// New admin registration is disabled for security purposes.

// Register new user
router.post('/register', validateRequest(userRegistrationSchema), async (req, res) => {
  try {
    const { email, password, firstName, lastName, phoneNumber, role, studentId, licenseNumber, vehicleNumber } = req.body;

    // Check if user already exists
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(409).json({
        error: 'User already exists',
        message: 'A user with this email already exists'
      });
    }

    // Check if this is an attempt to register an admin account
    // Block admin registration - only existing admin accounts are allowed
    if (email.toLowerCase().includes('admin') || 
        firstName.toLowerCase().includes('admin') || 
        lastName.toLowerCase().includes('admin') ||
        role === 'admin') {
      return res.status(403).json({
        error: 'Admin registration not allowed',
        message: 'Admin account registration is disabled. Please contact system administrator.'
      });
    }

    // Create new user
    const user = await User.create({
      email,
      password,
      firstName,
      lastName,
      phoneNumber,
      role: role || 'student',
      studentId,
      licenseNumber,
      vehicleNumber
    });

    // Generate JWT token
    const token = generateToken(user.id);

    res.status(201).json({
      message: 'User registered successfully',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phoneNumber: user.phone_number
      },
      token
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      error: 'Registration failed',
      message: 'An error occurred during registration'
    });
  }
});

// Login user
router.post('/login', validateRequest(userLoginSchema), async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(401).json({
        error: 'Invalid credentials',
        message: 'Email or password is incorrect'
      });
    }

    // Verify password
    const isPasswordValid = await User.verifyPassword(password, user.password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({
        error: 'Invalid credentials',
        message: 'Email or password is incorrect'
      });
    }

    // Generate JWT token
    const token = generateToken(user.id);

    res.json({
      message: 'Login successful',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phoneNumber: user.phone_number,
        role: user.role,
        studentId: user.student_id,
        licenseNumber: user.license_number,
        vehicleNumber: user.vehicle_number
      },
      token
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      error: 'Login failed',
      message: 'An error occurred during login'
    });
  }
});

// Verify token endpoint
router.get('/verify', require('../middleware/auth').authenticateToken, (req, res) => {
  res.json({
    message: 'Token is valid',
    user: {
      id: req.user.id,
      email: req.user.email,
      firstName: req.user.first_name,
      lastName: req.user.last_name,
      phoneNumber: req.user.phone_number
    }
  });
});


module.exports = router;
