import 'dart:developer';

/// Global service to store the current chat ID
/// This ensures the chat ID is accessible from anywhere in the app
class ChatIdService {
  static final ChatIdService _instance = ChatIdService._internal();
  factory ChatIdService() => _instance;
  ChatIdService._internal();

  int? _currentChatId;

  /// Get the current chat ID
  int? get currentChatId {
    log('📌 ChatIdService - Getting current chat ID: $_currentChatId');
    return _currentChatId;
  }

  /// Set the current chat ID
  void setChatId(int chatId) {
    log('📌 ChatIdService - Setting chat ID: $chatId');
    _currentChatId = chatId;
  }

  /// Clear the current chat ID
  void clearChatId() {
    log('📌 ChatIdService - Clearing chat ID');
    _currentChatId = null;
  }

  /// Check if a chat ID is set
  bool get hasChatId => _currentChatId != null;
}






