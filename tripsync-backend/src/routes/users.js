const express = require('express');
const router = express.Router();
const User = require('../models/User');
const { authenticateToken } = require('../middleware/auth');
const { validateRequest, userUpdateSchema } = require('../middleware/validation');

// Get all users (for admin management)
router.get('/', async (req, res) => {
  try {
    const users = await User.findAll();
    
    const formattedUsers = users.map(user => ({
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      phoneNumber: user.phone_number,
      role: user.role,
      studentId: user.student_id,
      licenseNumber: user.license_number,
      vehicleNumber: user.vehicle_number,
      createdAt: user.created_at,
      updatedAt: user.updated_at
    }));

    res.json(formattedUsers);
  } catch (error) {
    console.error('Get all users error:', error);
    res.status(500).json({
      error: 'Failed to get users',
      message: 'An error occurred while fetching users'
    });
  }
});

// Get current user profile
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    res.json({
      user: {
        id: req.user.id,
        email: req.user.email,
        firstName: req.user.first_name,
        lastName: req.user.last_name,
        phoneNumber: req.user.phone_number,
        createdAt: req.user.created_at,
        updatedAt: req.user.updated_at
      }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({
      error: 'Failed to get profile',
      message: 'An error occurred while fetching user profile'
    });
  }
});

// Update user profile
router.put('/profile', authenticateToken, validateRequest(userUpdateSchema), async (req, res) => {
  try {
    const { firstName, lastName, phoneNumber } = req.body;
    
    const updateData = {};
    if (firstName !== undefined) updateData.first_name = firstName;
    if (lastName !== undefined) updateData.last_name = lastName;
    if (phoneNumber !== undefined) updateData.phone_number = phoneNumber;

    const updatedUser = await User.updateById(req.user.id, updateData);

    res.json({
      message: 'Profile updated successfully',
      user: {
        id: updatedUser.id,
        email: updatedUser.email,
        firstName: updatedUser.first_name,
        lastName: updatedUser.last_name,
        phoneNumber: updatedUser.phone_number,
        createdAt: updatedUser.created_at,
        updatedAt: updatedUser.updated_at
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      error: 'Failed to update profile',
      message: 'An error occurred while updating user profile'
    });
  }
});

// Delete user account
router.delete('/profile', authenticateToken, async (req, res) => {
  try {
    await User.deleteById(req.user.id);
    
    res.json({
      message: 'Account deleted successfully'
    });
  } catch (error) {
    console.error('Delete account error:', error);
    res.status(500).json({
      error: 'Failed to delete account',
      message: 'An error occurred while deleting user account'
    });
  }
});

// Search users by email (for adding to trips)
router.get('/search', authenticateToken, async (req, res) => {
  try {
    const { email } = req.query;
    
    if (!email) {
      return res.status(400).json({
        error: 'Missing parameter',
        message: 'Email parameter is required'
      });
    }

    const user = await User.findByEmail(email);
    
    if (!user) {
      return res.status(404).json({
        error: 'User not found',
        message: 'No user found with this email'
      });
    }

    res.json({
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name
      }
    });
  } catch (error) {
    console.error('Search user error:', error);
    res.status(500).json({
      error: 'Search failed',
      message: 'An error occurred while searching for user'
    });
  }
});

module.exports = router;
