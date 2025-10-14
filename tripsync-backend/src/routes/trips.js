const express = require('express');
const router = express.Router();
const Trip = require('../models/Trip');
const { authenticateToken } = require('../middleware/auth');
const { validateRequest, tripCreationSchema, tripUpdateSchema } = require('../middleware/validation');

// Get all trips for authenticated user
router.get('/', authenticateToken, async (req, res) => {
  try {
    const trips = await Trip.findByUserId(req.user.id);
    
    res.json({
      trips: trips.map(trip => ({
        id: trip.id,
        title: trip.title,
        description: trip.description,
        destination: trip.destination,
        startDate: trip.start_date,
        endDate: trip.end_date,
        budget: trip.budget,
        createdBy: trip.created_by,
        creatorName: `${trip.first_name} ${trip.last_name}`,
        createdAt: trip.created_at,
        updatedAt: trip.updated_at
      }))
    });
  } catch (error) {
    console.error('Get trips error:', error);
    res.status(500).json({
      error: 'Failed to get trips',
      message: 'An error occurred while fetching trips'
    });
  }
});

// Get specific trip by ID
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const trip = await Trip.findById(id);
    
    if (!trip) {
      return res.status(404).json({
        error: 'Trip not found',
        message: 'The requested trip does not exist'
      });
    }

    // Check if user has access to this trip
    const participants = await Trip.getParticipants(id);
    const hasAccess = trip.created_by === req.user.id || 
                     participants.some(p => p.id === req.user.id);
    
    if (!hasAccess) {
      return res.status(403).json({
        error: 'Access denied',
        message: 'You do not have permission to view this trip'
      });
    }

    res.json({
      trip: {
        id: trip.id,
        title: trip.title,
        description: trip.description,
        destination: trip.destination,
        startDate: trip.start_date,
        endDate: trip.end_date,
        budget: trip.budget,
        createdBy: trip.created_by,
        creatorName: `${trip.first_name} ${trip.last_name}`,
        creatorEmail: trip.creator_email,
        createdAt: trip.created_at,
        updatedAt: trip.updated_at
      },
      participants
    });
  } catch (error) {
    console.error('Get trip error:', error);
    res.status(500).json({
      error: 'Failed to get trip',
      message: 'An error occurred while fetching trip details'
    });
  }
});

// Create new trip
router.post('/', authenticateToken, validateRequest(tripCreationSchema), async (req, res) => {
  try {
    const { title, description, destination, startDate, endDate, budget } = req.body;
    
    const trip = await Trip.create({
      title,
      description,
      destination,
      startDate,
      endDate,
      budget,
      createdBy: req.user.id
    });

    res.status(201).json({
      message: 'Trip created successfully',
      trip: {
        id: trip.id,
        title: trip.title,
        description: trip.description,
        destination: trip.destination,
        startDate: trip.start_date,
        endDate: trip.end_date,
        budget: trip.budget,
        createdBy: trip.created_by,
        createdAt: trip.created_at,
        updatedAt: trip.updated_at
      }
    });
  } catch (error) {
    console.error('Create trip error:', error);
    res.status(500).json({
      error: 'Failed to create trip',
      message: 'An error occurred while creating the trip'
    });
  }
});

// Update trip
router.put('/:id', authenticateToken, validateRequest(tripUpdateSchema), async (req, res) => {
  try {
    const { id } = req.params;
    const trip = await Trip.findById(id);
    
    if (!trip) {
      return res.status(404).json({
        error: 'Trip not found',
        message: 'The requested trip does not exist'
      });
    }

    // Only trip creator can update the trip
    if (trip.created_by !== req.user.id) {
      return res.status(403).json({
        error: 'Access denied',
        message: 'Only the trip creator can update this trip'
      });
    }

    const updateData = {};
    const { title, description, destination, startDate, endDate, budget } = req.body;
    
    if (title !== undefined) updateData.title = title;
    if (description !== undefined) updateData.description = description;
    if (destination !== undefined) updateData.destination = destination;
    if (startDate !== undefined) updateData.start_date = startDate;
    if (endDate !== undefined) updateData.end_date = endDate;
    if (budget !== undefined) updateData.budget = budget;

    const updatedTrip = await Trip.updateById(id, updateData);

    res.json({
      message: 'Trip updated successfully',
      trip: {
        id: updatedTrip.id,
        title: updatedTrip.title,
        description: updatedTrip.description,
        destination: updatedTrip.destination,
        startDate: updatedTrip.start_date,
        endDate: updatedTrip.end_date,
        budget: updatedTrip.budget,
        createdBy: updatedTrip.created_by,
        createdAt: updatedTrip.created_at,
        updatedAt: updatedTrip.updated_at
      }
    });
  } catch (error) {
    console.error('Update trip error:', error);
    res.status(500).json({
      error: 'Failed to update trip',
      message: 'An error occurred while updating the trip'
    });
  }
});

// Delete trip
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const trip = await Trip.findById(id);
    
    if (!trip) {
      return res.status(404).json({
        error: 'Trip not found',
        message: 'The requested trip does not exist'
      });
    }

    // Only trip creator can delete the trip
    if (trip.created_by !== req.user.id) {
      return res.status(403).json({
        error: 'Access denied',
        message: 'Only the trip creator can delete this trip'
      });
    }

    await Trip.deleteById(id);

    res.json({
      message: 'Trip deleted successfully'
    });
  } catch (error) {
    console.error('Delete trip error:', error);
    res.status(500).json({
      error: 'Failed to delete trip',
      message: 'An error occurred while deleting the trip'
    });
  }
});

// Add participant to trip
router.post('/:id/participants', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;
    
    if (!userId) {
      return res.status(400).json({
        error: 'Missing parameter',
        message: 'userId is required'
      });
    }

    const trip = await Trip.findById(id);
    
    if (!trip) {
      return res.status(404).json({
        error: 'Trip not found',
        message: 'The requested trip does not exist'
      });
    }

    // Only trip creator can add participants
    if (trip.created_by !== req.user.id) {
      return res.status(403).json({
        error: 'Access denied',
        message: 'Only the trip creator can add participants'
      });
    }

    await Trip.addParticipant(id, userId);
    const participants = await Trip.getParticipants(id);

    res.json({
      message: 'Participant added successfully',
      participants
    });
  } catch (error) {
    console.error('Add participant error:', error);
    res.status(500).json({
      error: 'Failed to add participant',
      message: 'An error occurred while adding participant to trip'
    });
  }
});

// Remove participant from trip
router.delete('/:id/participants/:userId', authenticateToken, async (req, res) => {
  try {
    const { id, userId } = req.params;
    
    const trip = await Trip.findById(id);
    
    if (!trip) {
      return res.status(404).json({
        error: 'Trip not found',
        message: 'The requested trip does not exist'
      });
    }

    // Only trip creator can remove participants
    if (trip.created_by !== req.user.id) {
      return res.status(403).json({
        error: 'Access denied',
        message: 'Only the trip creator can remove participants'
      });
    }

    const removed = await Trip.removeParticipant(id, userId);
    
    if (!removed) {
      return res.status(404).json({
        error: 'Participant not found',
        message: 'The user is not a participant in this trip'
      });
    }

    const participants = await Trip.getParticipants(id);

    res.json({
      message: 'Participant removed successfully',
      participants
    });
  } catch (error) {
    console.error('Remove participant error:', error);
    res.status(500).json({
      error: 'Failed to remove participant',
      message: 'An error occurred while removing participant from trip'
    });
  }
});

module.exports = router;
