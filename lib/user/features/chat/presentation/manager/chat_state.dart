import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';

class ChatState {
  final List<ChatModel> chats;
  final List<MessageModel> messages;
  final bool isLoading;
    final List<MessageModel> pendingMessages; // unsent messages

  final bool isLoadingMessages;
  final String? error;
  final int? selectedChatId;
  final bool isWebSocketConnected;
  final bool isCreatingChat;

  const ChatState({
    this.chats = const [],this.pendingMessages = const  [] ,
    this.messages = const [],
    this.isLoading = false,
    this.isLoadingMessages = false,
    this.error,
    this.selectedChatId,
    this.isWebSocketConnected = false,
    this.isCreatingChat = false,
  });

  ChatState copyWith({
    List<ChatModel>? chats,
    List<MessageModel>? messages,
    List<MessageModel>? pendingMessages ,
    bool? isLoading,
    bool? isLoadingMessages,
    String? error,
    int? selectedChatId,
    bool? isWebSocketConnected,
    bool? isCreatingChat,
  }) {
    return ChatState(
      // Create new list instances to ensure state changes are detected
      chats: chats != null ? List<ChatModel>.from(chats) : this.chats,
      messages: messages != null ? List<MessageModel>.from(messages) : this.messages,
      pendingMessages: pendingMessages != null ? List<MessageModel>.from(pendingMessages) : this.pendingMessages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      error: error,
      selectedChatId: selectedChatId,
      isWebSocketConnected: isWebSocketConnected ?? this.isWebSocketConnected,
      isCreatingChat: isCreatingChat ?? this.isCreatingChat,
    );
  }
}
