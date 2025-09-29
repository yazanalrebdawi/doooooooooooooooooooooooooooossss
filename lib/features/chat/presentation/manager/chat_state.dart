import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';

class ChatState {
  final List<ChatModel> chats;
  final List<MessageModel> messages;
  final bool isLoading;
<<<<<<< HEAD
    final List<MessageModel> pendingMessages; // unsent messages

=======
>>>>>>> zoz
  final bool isLoadingMessages;
  final String? error;
  final int? selectedChatId;
  final bool isWebSocketConnected;
  final bool isCreatingChat;

  const ChatState({
<<<<<<< HEAD
    this.chats = const [],this.pendingMessages = const  [] ,
=======
    this.chats = const [],
>>>>>>> zoz
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
<<<<<<< HEAD
    List<MessageModel>? pendingMessages ,
=======
>>>>>>> zoz
    bool? isLoading,
    bool? isLoadingMessages,
    String? error,
    int? selectedChatId,
    bool? isWebSocketConnected,
    bool? isCreatingChat,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
<<<<<<< HEAD
      pendingMessages: pendingMessages ?? this.pendingMessages,
=======
>>>>>>> zoz
      isLoading: isLoading ?? this.isLoading,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      error: error,
      selectedChatId: selectedChatId,
      isWebSocketConnected: isWebSocketConnected ?? this.isWebSocketConnected,
      isCreatingChat: isCreatingChat ?? this.isCreatingChat,
    );
  }
}
