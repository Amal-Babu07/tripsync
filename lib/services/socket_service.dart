import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;
  static const String serverUrl = 'http://192.168.4.218:5005'; // PostgreSQL Backend Port 5005
  
  // Initialize socket connection
  static void connect() {
    if (socket != null && socket!.connected) {
      print('✅ Socket already connected');
      return;
    }
    
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket!.connect();
    
    socket!.onConnect((_) {
      print('✅ Connected to Socket.IO server');
    });
    
    socket!.onDisconnect((_) {
      print('❌ Disconnected from Socket.IO server');
    });
    
    socket!.onError((error) {
      print('❌ Socket error: $error');
    });
  }
  
  // Track a specific bus (Student)
  static void trackBus(String busId) {
    if (socket != null && socket!.connected) {
      socket!.emit('trackBus', busId);
      print('📍 Tracking bus: $busId');
    } else {
      print('❌ Socket not connected. Call connect() first.');
    }
  }
  
  // Join bus room (Driver)
  static void joinBusRoom(String busId) {
    if (socket != null && socket!.connected) {
      socket!.emit('joinBusRoom', busId);
      print('🚌 Joined bus room: $busId');
    } else {
      print('❌ Socket not connected. Call connect() first.');
    }
  }
  
  // Update location (Driver)
  static void updateLocation(
    String busId,
    double latitude,
    double longitude,
    String nextStop,
  ) {
    if (socket != null && socket!.connected) {
      socket!.emit('updateLocation', {
        'busId': busId,
        'latitude': latitude,
        'longitude': longitude,
        'nextStop': nextStop,
      });
      print('📡 Location updated for bus: $busId');
    } else {
      print('❌ Socket not connected. Call connect() first.');
    }
  }
  
  // Update driver status
  static void updateDriverStatus(String busId, String status) {
    if (socket != null && socket!.connected) {
      socket!.emit('driverStatus', {
        'busId': busId,
        'status': status,
      });
      print('🔄 Driver status updated: $status');
    }
  }
  
  // Listen for location updates
  static void onLocationUpdate(Function(Map<String, dynamic>) callback) {
    if (socket != null) {
      socket!.on('locationUpdate', (data) {
        print('📍 Received location update: $data');
        callback(data as Map<String, dynamic>);
      });
    }
  }
  
  // Listen for bus status updates
  static void onBusStatusUpdate(Function(Map<String, dynamic>) callback) {
    if (socket != null) {
      socket!.on('busStatusUpdate', (data) {
        print('🔄 Received bus status update: $data');
        callback(data as Map<String, dynamic>);
      });
    }
  }
  
  // Remove all listeners
  static void removeAllListeners() {
    if (socket != null) {
      socket!.off('locationUpdate');
      socket!.off('busStatusUpdate');
      print('🔇 Removed all socket listeners');
    }
  }
  
  // Disconnect
  static void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket = null;
      print('👋 Socket disconnected');
    }
  }
  
  // Check connection status
  static bool isConnected() {
    return socket != null && socket!.connected;
  }
}
