import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // TripSync Backend API
  // Change this based on your testing environment:
  // Android Emulator: http://10.0.2.2:3000
  // iOS Simulator: http://localhost:3000
  // Real Device (same WiFi): http://YOUR_LOCAL_IP:3000
  // Windows local development: http://localhost:3000
  static const String baseUrl = 'https://tripsync-backend-53oj.onrender.com/api';
  
  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  // Clear token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
  
  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
  
  // Register
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
  
  // Verify token
  static Future<Map<String, dynamic>> verifyToken() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/verify'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Token verification failed');
    }
  }

  // Get current user profile
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final token = await getToken();
    final Map<String, dynamic> body = {};
    
    if (firstName != null) body['firstName'] = firstName;
    if (lastName != null) body['lastName'] = lastName;
    if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
    
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  // Search user by email
  static Future<Map<String, dynamic>> searchUser(String email) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/search?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User not found');
    }
  }
  
  // Get all trips for user
  static Future<List<dynamic>> getTrips() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/trips'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['trips'];
    } else {
      throw Exception('Failed to load trips');
    }
  }
  
  // Get single trip
  static Future<Map<String, dynamic>> getTripById(int tripId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/trips/$tripId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load trip');
    }
  }
  
  // Create new trip
  static Future<Map<String, dynamic>> createTrip({
    required String title,
    required String destination,
    required String startDate,
    required String endDate,
    String? description,
    double? budget,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/trips'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'destination': destination,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
        'budget': budget,
      }),
    );
    
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to create trip');
    }
  }
  
  // Update trip
  static Future<Map<String, dynamic>> updateTrip(
    int tripId,
    Map<String, dynamic> updates,
  ) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/trips/$tripId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updates),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update trip');
    }
  }
  
  // Delete trip
  static Future<void> deleteTrip(int tripId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/trips/$tripId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete trip');
    }
  }
  
  // Add participant to trip
  static Future<Map<String, dynamic>> addParticipant(int tripId, int userId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/trips/$tripId/participants'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add participant');
    }
  }
  
  // Remove participant from trip
  static Future<Map<String, dynamic>> removeParticipant(int tripId, int userId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/trips/$tripId/participants/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove participant');
    }
  }
  
  // Health check
  static Future<Map<String, dynamic>> healthCheck() async {
    final response = await http.get(
      Uri.parse('${baseUrl.replaceAll('/api', '')}/health'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Health check failed');
    }
  }
}
