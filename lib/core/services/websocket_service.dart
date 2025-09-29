import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../network/api_urls.dart';

class WebSocketService {
  WebSocket? _socket;
  String? _accessToken;
  int? _chatId;
  bool _isConnected = false;
  bool _isConnecting = false;
  
  // Callbacks
  Function(String)? onMessageReceived;
  Function(String)? onError;
  VoidCallback? onConnected;
  VoidCallback? onDisconnected;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;

  Future<void> connect(int chatId, String accessToken) async {
    if (_isConnecting) {
      print('⚠️ WebSocket: Already connecting, skipping...');
      return;
    }
    
    if (_isConnected) {
      print('⚠️ WebSocket: Already connected, disconnecting first...');
      disconnect();
    }
    
    _chatId = chatId;
    _accessToken = accessToken;
    _isConnecting = true;
    
    final wsUrl = '${ApiUrls.wsBaseUrl}/ws/chats/$chatId/?token=$accessToken';
    print('🔌 WebSocket: Connecting to $wsUrl');
    
    try {
      _socket = await WebSocket.connect(wsUrl);
      
      _socket!.listen(
        (message) {
          print('📨 WebSocket: Message received: $message');
          _handleMessage(message);
        },
        onError: (error) {
          print('❌ WebSocket: Error: $error');
          _isConnected = false;
          _isConnecting = false;
          onError?.call(error.toString());
        },
        onDone: () {
          print('🔌 WebSocket: Connection closed');
          _isConnected = false;
          _isConnecting = false;
          onDisconnected?.call();
        },
      );
      
      _isConnected = true;
      _isConnecting = false;
      onConnected?.call();
      print('✅ WebSocket: Connected successfully');
    } catch (e) {
      print('❌ WebSocket: Connection failed: $e');
      _isConnected = false;
      _isConnecting = false;
      onError?.call(e.toString());
    }
  }

  void disconnect() {
    print('🔌 WebSocket: Disconnecting...');
    _socket?.close();
    _socket = null;
    _isConnected = false;
    onDisconnected?.call();
  }

  void sendMessage(String text) {
    if (!_isConnected || _socket == null) {
      print('❌ WebSocket: Not connected, cannot send message');
      onError?.call('Not connected to chat server');
      return;
    }

    final message = {
      'action': 'send',
      'text': text,
    };

    final jsonMessage = jsonEncode(message);
    print('📤 WebSocket: Sending message: $jsonMessage');
    
    try {
      _socket!.add(jsonMessage);
    } catch (e) {
      print('❌ WebSocket: Failed to send message: $e');
      onError?.call('Failed to send message: $e');
    }
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        print('📨 WebSocket: Parsed message: $data');
        onMessageReceived?.call(data.toString());
      } else {
        print('📨 WebSocket: Raw message: $message');
        onMessageReceived?.call(message.toString());
      }
    } catch (e) {
      print('❌ WebSocket: Error parsing message: $e');
      onError?.call('Error parsing message: $e');
    }
  }

  void dispose() {
    disconnect();
  }

  // Test connection method
  Future<bool> testConnection() async {
    if (!_isConnected) {
      print('❌ WebSocket: Not connected for testing');
      return false;
    }
    
    try {
      final testMessage = {
        'action': 'ping',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      _socket!.add(jsonEncode(testMessage));
      print('✅ WebSocket: Test message sent');
      return true;
    } catch (e) {
      print('❌ WebSocket: Test failed: $e');
      return false;
    }
  }

  // Get connection status
  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isConnected,
      'isConnecting': _isConnecting,
      'chatId': _chatId,
      'hasAccessToken': _accessToken != null && _accessToken!.isNotEmpty,
    };
  }
}
