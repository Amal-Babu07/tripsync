// Example API client for TripSync Backend
// This demonstrates how to interact with the API

const axios = require('axios');

class TripSyncClient {
  constructor(baseURL = 'http://localhost:3000/api') {
    this.baseURL = baseURL;
    this.token = null;
    this.client = axios.create({
      baseURL: this.baseURL,
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json'
      }
    });

    // Add request interceptor to include auth token
    this.client.interceptors.request.use(
      (config) => {
        if (this.token) {
          config.headers.Authorization = `Bearer ${this.token}`;
        }
        return config;
      },
      (error) => {
        return Promise.reject(error);
      }
    );
  }

  // Authentication methods
  async register(userData) {
    try {
      const response = await this.client.post('/auth/register', userData);
      this.token = response.data.token;
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async login(email, password) {
    try {
      const response = await this.client.post('/auth/login', { email, password });
      this.token = response.data.token;
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async verifyToken() {
    try {
      const response = await this.client.get('/auth/verify');
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // User methods
  async getProfile() {
    try {
      const response = await this.client.get('/users/profile');
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async updateProfile(updateData) {
    try {
      const response = await this.client.put('/users/profile', updateData);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async searchUser(email) {
    try {
      const response = await this.client.get(`/users/search?email=${email}`);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Trip methods
  async getTrips() {
    try {
      const response = await this.client.get('/trips');
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async getTrip(tripId) {
    try {
      const response = await this.client.get(`/trips/${tripId}`);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async createTrip(tripData) {
    try {
      const response = await this.client.post('/trips', tripData);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async updateTrip(tripId, updateData) {
    try {
      const response = await this.client.put(`/trips/${tripId}`, updateData);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async deleteTrip(tripId) {
    try {
      const response = await this.client.delete(`/trips/${tripId}`);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async addParticipant(tripId, userId) {
    try {
      const response = await this.client.post(`/trips/${tripId}/participants`, { userId });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  async removeParticipant(tripId, userId) {
    try {
      const response = await this.client.delete(`/trips/${tripId}/participants/${userId}`);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Health check
  async healthCheck() {
    try {
      const response = await axios.get(`${this.baseURL.replace('/api', '')}/health`);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Error handler
  handleError(error) {
    if (error.response) {
      // Server responded with error status
      return {
        status: error.response.status,
        message: error.response.data.message || 'An error occurred',
        error: error.response.data.error || 'Unknown error',
        details: error.response.data.details || null
      };
    } else if (error.request) {
      // Request was made but no response received
      return {
        status: 0,
        message: 'Network error - no response from server',
        error: 'Network Error'
      };
    } else {
      // Something else happened
      return {
        status: 0,
        message: error.message || 'An unexpected error occurred',
        error: 'Client Error'
      };
    }
  }

  // Utility method to set token manually
  setToken(token) {
    this.token = token;
  }

  // Utility method to clear token
  clearToken() {
    this.token = null;
  }
}

// Example usage
async function example() {
  const client = new TripSyncClient();

  try {
    // Health check
    console.log('Health check:', await client.healthCheck());

    // Register a new user
    const userData = {
      email: 'example@test.com',
      password: 'password123',
      firstName: 'Example',
      lastName: 'User',
      phoneNumber: '+1-555-0123'
    };

    const registerResult = await client.register(userData);
    console.log('Registration successful:', registerResult.user);

    // Get user profile
    const profile = await client.getProfile();
    console.log('User profile:', profile.user);

    // Create a trip
    const tripData = {
      title: 'Weekend Getaway',
      description: 'A relaxing weekend trip',
      destination: 'Lake Tahoe',
      startDate: '2024-08-15',
      endDate: '2024-08-17',
      budget: 800
    };

    const trip = await client.createTrip(tripData);
    console.log('Trip created:', trip.trip);

    // Get all trips
    const trips = await client.getTrips();
    console.log('All trips:', trips.trips);

  } catch (error) {
    console.error('API Error:', error);
  }
}

// Uncomment to run the example
// example();

module.exports = TripSyncClient;
