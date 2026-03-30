import 'dart:convert';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:guyana_center_frontend/modal/chat_user.dart';
import 'package:guyana_center_frontend/modal/socket_message.dart';
import 'package:guyana_center_frontend/services/message_storage_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  final _messageControllers = <String, Function(dynamic)>{};
  Function(dynamic)? _globalMessageListener;

  // Get socket instance
  IO.Socket? get socket => _socket;

  // Connect to socket server
  void connect() {
    if (_socket != null && _socket!.connected) {
      print('✅ Already connected to socket server');
      return;
    }

    final token = AuthService.to.accessToken.value;
    if (token.isEmpty) {
      print('❌ No auth token, cannot connect to socket');
      return;
    }

    _socket = IO.io(
      ApiService.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(10000)
          .setAuth({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      print('✅ Connected to socket server');
    });

    _socket!.onDisconnect((_) {
      print('❌ Disconnected from socket server');
    });

    _socket!.onError((data) {
      print('❌ Socket error: $data');
    });

    _socket!.on('connect_error', (data) {
      print('❌ Connect error: $data');
    });

    // Listen for incoming messages
    _socket!.on('new_message', (data) {
      print('📩 New message received: $data');
      final conversationId = data['conversationId'] ?? '';
      
      // Trigger global listener (for unread counts etc)
      if (_globalMessageListener != null) {
        _globalMessageListener!(data);
      }
      
      // Trigger specific conversation listener
      if (_messageControllers.containsKey(conversationId)) {
        _messageControllers[conversationId]!(data);
      }
    });

    // Listen for message acknowledgment
    _socket!.on('message_sent', (data) {
      print('✅ Message sent successfully: $data');
    });

    // Connect with authentication
    _socket!.connect();
  }

  // Disconnect from socket server
  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _socket = null;
      print('Disconnected from socket server');
    }
  }

  // Send a message
  void sendMessage({
    required String conversationId,
    required String text,
    required int listingId,
    String? imageUrl,
    String? imageBase64,
  }) {
    if (_socket == null || !_socket!.connected) {
      connect();
      if (_socket == null || !_socket!.connected) {
        print('❌ Socket not connected');
        return;
      }
    }

    _socket!.emit('send_message', {
      'conversationId': conversationId,
      'text': text,
      'listingId': listingId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (imageBase64 != null) 'imageBase64': imageBase64,
    });
  }

  // Join a conversation room
  void joinConversation(String conversationId) {
    if (_socket == null || !_socket!.connected) {
      connect();
      if (_socket == null || !_socket!.connected) {
        print('❌ Socket not connected');
        return;
      }
    }

    _socket!.emit('join_conversation', conversationId);
    print('🚪 Joined conversation room: $conversationId');
  }

  // Leave a conversation room
  void leaveConversation(String conversationId) {
    if (_socket == null || !_socket!.connected) {
      return;
    }

    _socket!.emit('leave_conversation', conversationId);
    print('🚪 Left conversation room: $conversationId');
  }

  // Register a global message listener
  void onGlobalMessage(Function(dynamic) callback) {
    _globalMessageListener = callback;
  }

  // Register a message listener for a conversation
  void onMessage(String conversationId, Function(dynamic) callback) {
    _messageControllers[conversationId] = callback;
  }

  // Remove a message listener
  void removeMessageListener(String conversationId) {
    _messageControllers.remove(conversationId);
  }

  // Check if connected
  bool get isConnected => _socket != null && _socket!.connected;
}
