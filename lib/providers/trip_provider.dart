import 'package:flutter/foundation.dart';
import '../models/trip.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class TripProvider with ChangeNotifier {
  List<Trip> _trips = [];
  Trip? _selectedTrip;
  bool _isLoading = false;
  String? _error;

  List<Trip> get trips => _trips;
  Trip? get selectedTrip => _selectedTrip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter trips by status
  List<Trip> get upcomingTrips => _trips.where((trip) => trip.isUpcoming).toList();
  List<Trip> get ongoingTrips => _trips.where((trip) => trip.isOngoing).toList();
  List<Trip> get pastTrips => _trips.where((trip) => trip.isPast).toList();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setTrips(List<Trip> trips) {
    _trips = trips;
    notifyListeners();
  }

  void _setSelectedTrip(Trip? trip) {
    _selectedTrip = trip;
    notifyListeners();
  }

  // Load all trips
  Future<void> loadTrips() async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.getTrips();
      final trips = response.map((tripJson) => Trip.fromJson(tripJson)).toList();
      _setTrips(trips);
      _setError(null);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  // Load specific trip with participants
  Future<void> loadTrip(int tripId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.getTripById(tripId);
      final trip = Trip.fromJson(response['trip']);
      final participants = (response['participants'] as List?)
          ?.map((p) => TripParticipant.fromJson(p))
          .toList();
      
      _setSelectedTrip(trip.copyWith(participants: participants));
      _setError(null);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  // Create new trip
  Future<bool> createTrip({
    required String title,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    double? budget,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.createTrip(
        title: title,
        destination: destination,
        startDate: startDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
        endDate: endDate.toIso8601String().split('T')[0],
        description: description,
        budget: budget,
      );
      
      final newTrip = Trip.fromJson(response['trip']);
      _trips.insert(0, newTrip); // Add to beginning of list
      _setError(null);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Update trip
  Future<bool> updateTrip(int tripId, Map<String, dynamic> updates) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Convert DateTime objects to strings if present
      final processedUpdates = Map<String, dynamic>.from(updates);
      if (processedUpdates['startDate'] is DateTime) {
        processedUpdates['startDate'] = 
            (processedUpdates['startDate'] as DateTime).toIso8601String().split('T')[0];
      }
      if (processedUpdates['endDate'] is DateTime) {
        processedUpdates['endDate'] = 
            (processedUpdates['endDate'] as DateTime).toIso8601String().split('T')[0];
      }
      
      final response = await ApiService.updateTrip(tripId, processedUpdates);
      final updatedTrip = Trip.fromJson(response['trip']);
      
      // Update in local list
      final index = _trips.indexWhere((trip) => trip.id == tripId);
      if (index != -1) {
        _trips[index] = updatedTrip;
      }
      
      // Update selected trip if it's the same
      if (_selectedTrip?.id == tripId) {
        _setSelectedTrip(updatedTrip.copyWith(participants: _selectedTrip?.participants));
      }
      
      _setError(null);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Delete trip
  Future<bool> deleteTrip(int tripId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await ApiService.deleteTrip(tripId);
      
      // Remove from local list
      _trips.removeWhere((trip) => trip.id == tripId);
      
      // Clear selected trip if it's the deleted one
      if (_selectedTrip?.id == tripId) {
        _setSelectedTrip(null);
      }
      
      _setError(null);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Add participant to trip
  Future<bool> addParticipant(int tripId, int userId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.addParticipant(tripId, userId);
      final participants = (response['participants'] as List)
          .map((p) => TripParticipant.fromJson(p))
          .toList();
      
      // Update selected trip participants
      if (_selectedTrip?.id == tripId) {
        _setSelectedTrip(_selectedTrip!.copyWith(participants: participants));
      }
      
      _setError(null);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Remove participant from trip
  Future<bool> removeParticipant(int tripId, int userId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.removeParticipant(tripId, userId);
      final participants = (response['participants'] as List)
          .map((p) => TripParticipant.fromJson(p))
          .toList();
      
      // Update selected trip participants
      if (_selectedTrip?.id == tripId) {
        _setSelectedTrip(_selectedTrip!.copyWith(participants: participants));
      }
      
      _setError(null);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Search user by email
  Future<User?> searchUser(String email) async {
    try {
      final response = await ApiService.searchUser(email);
      return User.fromJson(response['user']);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Clear selected trip
  void clearSelectedTrip() {
    _setSelectedTrip(null);
  }

  // Refresh trips
  Future<void> refreshTrips() async {
    await loadTrips();
  }
}
