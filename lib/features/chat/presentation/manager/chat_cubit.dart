<<<<<<< HEAD
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import 'package:dooss_business_app/features/chat/data/models/message_model.dart';
import 'package:dooss_business_app/features/chat/data/models/socket_message.dart';
=======
import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
>>>>>>> zoz
import 'chat_state.dart';
import '../../data/data_source/chat_remote_data_source.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../core/services/token_service.dart';
<<<<<<< HEAD
import 'package:connectivity_plus/connectivity_plus.dart';

class ChatCubit extends OptimizedCubit<ChatState> {
  final ChatRemoteDataSource dataSource;
  final WebSocketService _webSocketService = di.sl<WebSocketService>();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
=======

class ChatCubit extends OptimizedCubit<ChatState> {
  final ChatRemoteDataSource dataSource;
  final WebSocketService _webSocketService = di.appLocator<WebSocketService>();
>>>>>>> zoz

  ChatCubit(this.dataSource) : super(const ChatState()) {
    print('ChatCubit - Initialized');
    _setupWebSocketCallbacks();
<<<<<<< HEAD
    _monitorConnectivity();
  }
  void _monitorConnectivity() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) async {
      final hasInternet =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (hasInternet && state.selectedChatId != null) {
        if (!_webSocketService.isConnected && !_webSocketService.isConnecting) {
          final accessToken = await TokenService.getAccessToken();
          if (accessToken != null) {
            print('🌐 Internet back, reconnecting WebSocket...');
            await _webSocketService.connect(state.selectedChatId!, accessToken);
            // ❌ No _resendPendingMessages() here anymore
          }
        }
      }
    });
  }

//   void _setupWebSocketCallbacks() {
//   _webSocketService.onConnected = () {
//     print('✅ ChatCubit: WebSocket connected');
//     safeEmit(state.copyWith(isWebSocketConnected: true));

//     // 🔑 Resend pending messages *after* the socket is ready
//     _resendPendingMessages();
//   };

//   _webSocketService.onDisconnected = () {
//     print('🔌 ChatCubit: WebSocket disconnected');
//     safeEmit(state.copyWith(isWebSocketConnected: false));
//   };

//   _webSocketService.onMessageReceived = (message) {
//     print('📨 ChatCubit: Message received via WebSocket: $message');
//     _handleIncomingMessage(message);
//   };

//   _webSocketService.onError = (error) {
//     print('❌ ChatCubit: WebSocket error: $error');
//     safeEmit(state.copyWith(error: 'WebSocket error: $error'));
//   };
// }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _webSocketService.dispose();
    return super.close();
=======
>>>>>>> zoz
  }

  void _setupWebSocketCallbacks() {
    _webSocketService.onConnected = () {
      print('✅ ChatCubit: WebSocket connected');
      safeEmit(state.copyWith(isWebSocketConnected: true));
<<<<<<< HEAD
      _resendPendingMessages();
=======
>>>>>>> zoz
    };

    _webSocketService.onDisconnected = () {
      print('🔌 ChatCubit: WebSocket disconnected');
      safeEmit(state.copyWith(isWebSocketConnected: false));
    };

    _webSocketService.onMessageReceived = (message) {
      print('📨 ChatCubit: Message received via WebSocket: $message');
      // Handle incoming message
      _handleIncomingMessage(message);
    };

    _webSocketService.onError = (error) {
      print('❌ ChatCubit: WebSocket error: $error');
      safeEmit(state.copyWith(error: 'WebSocket error: $error'));
    };
  }

<<<<<<< HEAD
=======
  //! Done
>>>>>>> zoz
  void loadChats() async {
    print('ChatCubit - loadChats() called');
    safeEmit(state.copyWith(isLoading: true, error: null));
    try {
      print('ChatCubit - Calling dataSource.fetchChats()');
      final chats = await dataSource.fetchChats();
      print('ChatCubit - Received ${chats.length} chats from dataSource');
<<<<<<< HEAD
      safeEmit(state.copyWith(
        chats: chats,
        isLoading: false,
      ));
=======
      safeEmit(state.copyWith(chats: chats, isLoading: false));
>>>>>>> zoz
      print('ChatCubit - State updated with ${state.chats.length} chats');
    } catch (e) {
      print('ChatCubit error: $e');
      safeEmit(state.copyWith(error: 'Failed to load chats', isLoading: false));
    }
  }

  void loadMessages(int chatId) async {
    print('ChatCubit - loadMessages() called with chatId: $chatId');
<<<<<<< HEAD
    safeEmit(state.copyWith(
        isLoadingMessages: true, error: null, selectedChatId: chatId));
=======
    safeEmit(
      state.copyWith(
        isLoadingMessages: true,
        error: null,
        selectedChatId: chatId,
      ),
    );
>>>>>>> zoz
    try {
      print('ChatCubit - Calling dataSource.fetchMessages()');
      final messages = await dataSource.fetchMessages(chatId);
      print('ChatCubit - Received ${messages.length} messages from dataSource');
<<<<<<< HEAD
      safeEmit(state.copyWith(
        messages: messages,
        selectedChatId: chatId,
        isLoadingMessages: false,
      ));
      print('ChatCubit - State updated with ${state.messages.length} messages');
    } catch (e) {
      print('ChatCubit loadMessages error: $e');
      safeEmit(state.copyWith(
          error: 'Failed to load messages', isLoadingMessages: false));
    }
  }

  void sendMessage(String content, int id) async {
=======
      safeEmit(state.copyWith(messages: messages, isLoadingMessages: false));
      print('ChatCubit - State updated with ${state.messages.length} messages');
    } catch (e) {
      print('ChatCubit loadMessages error: $e');
      safeEmit(
        state.copyWith(
          error: 'Failed to load messages',
          isLoadingMessages: false,
        ),
      );
    }
  }

  void sendMessage(String content) async {
>>>>>>> zoz
    print('ChatCubit - sendMessage() called with content: $content');
    if (state.selectedChatId == null) {
      print('ChatCubit - No selectedChatId, cannot send message');
      return;
    }

    try {
      print('ChatCubit - Calling dataSource.sendMessage()');
<<<<<<< HEAD
      final message =
          await dataSource.sendMessage(state.selectedChatId!, content);
=======
      final message = await dataSource.sendMessage(
        state.selectedChatId!,
        content,
      );
>>>>>>> zoz
      final updatedMessages = [...state.messages, message];
      safeEmit(state.copyWith(messages: updatedMessages));
      print('ChatCubit - Message sent successfully, state updated');
    } catch (e) {
      print('ChatCubit sendMessage error: $e');
      safeEmit(state.copyWith(error: 'Failed to send message'));
    }
  }

  void createChat(int dealerUserId) async {
    print('ChatCubit - createChat() called with dealerUserId: $dealerUserId');
    safeEmit(state.copyWith(isCreatingChat: true, error: null));

    try {
      final chat = await dataSource.createChat(dealerUserId);
      print('ChatCubit - Chat created successfully: ${chat.id}');

      // Add to chats list
      final updatedChats = [...state.chats, chat];
<<<<<<< HEAD
      safeEmit(state.copyWith(
        chats: updatedChats,
        selectedChatId: chat.id,
        isCreatingChat: false,
      ));
=======
      safeEmit(
        state.copyWith(
          chats: updatedChats,
          selectedChatId: chat.id,
          isCreatingChat: false,
        ),
      );
>>>>>>> zoz

      // Connect to WebSocket
      _connectToWebSocket(chat.id);
    } catch (e) {
      print('ChatCubit createChat error: $e');
<<<<<<< HEAD
      safeEmit(state.copyWith(
        error: 'Failed to create chat: $e',
        isCreatingChat: false,
      ));
=======
      safeEmit(
        state.copyWith(
          error: 'Failed to create chat: $e',
          isCreatingChat: false,
        ),
      );
>>>>>>> zoz
    }
  }

  void _connectToWebSocket(int chatId) async {
    final accessToken = await TokenService.getAccessToken();
    if (accessToken != null) {
      await _webSocketService.connect(chatId, accessToken);
<<<<<<< HEAD
      safeEmit(state.copyWith(isWebSocketConnected: true));
=======
>>>>>>> zoz
    } else {
      print('❌ ChatCubit: No access token found, cannot connect to WebSocket');
      safeEmit(state.copyWith(error: 'No access token found'));
    }
  }

  void _handleIncomingMessage(String message) {
    try {
<<<<<<< HEAD
      final decoded = jsonDecode(message);

      if (decoded is Map<String, dynamic> &&
          decoded['type'] == 'chat.message') {
        final socketMessage = SocketMessageModel.fromJson(decoded);

        final updatedMessages = state.messages.map((m) {
          final isSameText = m.text == socketMessage.text;
          final isPending = m.status == 'pending';
          return (isSameText && isPending)
              ? m.copyWith(
                  id: socketMessage.messageId,
                  status: socketMessage.status,
                  timestamp: socketMessage.timestamp,
                )
              : m;
        }).toList();

        final alreadyUpdated =
            updatedMessages.any((m) => m.id == socketMessage.messageId);

        final finalMessages = alreadyUpdated
            ? updatedMessages
            : [
                ...updatedMessages,
                MessageModel(
                    id: socketMessage.messageId,
                    sender: socketMessage.sender.toString(),
                    senderId: socketMessage.sender,
                    text: socketMessage.text,
                    type: socketMessage.messageType,
                    status: socketMessage.status,
                    imageUrl: socketMessage.imageUrl,
                    fileUrl: socketMessage.fileUrl,
                    fileSize: socketMessage.fileSize?.toString(),
                    timestamp: socketMessage.timestamp,
                    isMine: true),
              ];

        // ✅ Sort messages by timestamp to ensure proper order
        finalMessages.sort((a, b) =>
            DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));

        safeEmit(state.copyWith(messages: finalMessages));
      }
    } catch (e) {
      print('ChatCubit: Error decoding message: $e');
    }
  }

  int? _parseIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) return value.toInt();
    return null;
  }

=======
      // Parse incoming message and add to messages list
      // This will be implemented based on the actual message format
      print('ChatCubit: Handling incoming message: $message');
    } catch (e) {
      print('ChatCubit: Error handling incoming message: $e');
    }
  }

//!c ----
>>>>>>> zoz
  void sendMessageViaWebSocket(String text) {
    if (!state.isWebSocketConnected) {
      print('ChatCubit: WebSocket not connected, cannot send message');
      safeEmit(state.copyWith(error: 'Not connected to chat server'));
      return;
    }

    _webSocketService.sendMessage(text);
  }

  void disconnectWebSocket() {
    _webSocketService.disconnect();
  }

  void clearSelectedChat() {
    print('ChatCubit - clearSelectedChat() called');
    disconnectWebSocket();
<<<<<<< HEAD
    safeEmit(state.copyWith(
      selectedChatId: null,
      messages: [],
      isLoadingMessages: false,
    ));
  }

  connectWebSocket(int chatId) => _connectToWebSocket(chatId);

  void sendMessageOfflineSafe(String text) async {
    String? id = await TokenService.getUserId();
    // if (state.selectedChatId == null) return;

    final tempMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch, // temporary local ID
        sender: "me",
        senderId: int.tryParse(id ?? '0') ?? 0,
        text: text,
        type: "text",
        status: "pending", // <-- important
        timestamp: DateTime.now().toIso8601String(),
        isMine: true,
        fileUrl: '',
        imageUrl: '');

    // Show message immediately
  safeEmit(state.copyWith(
  messages: [...state.messages, tempMessage] // append at end
      ..sort((a, b) => DateTime.parse(a.timestamp)
          .compareTo(DateTime.parse(b.timestamp))),
  pendingMessages: [...state.pendingMessages, tempMessage],
));


    if (state.isWebSocketConnected) {
      _tryResend(tempMessage);
    }
  }

  void _resendPendingMessages() {
    if (!state.isWebSocketConnected) return;
    for (var msg in state.pendingMessages) {
      _tryResend(msg);
    }
  }

  void _tryResend(MessageModel msg) {
    try {
      _webSocketService.sendMessage(msg.text);
      // do NOT remove from pending yet; wait for server confirmation
    } catch (_) {}
=======
    safeEmit(
      state.copyWith(
        selectedChatId: null,
        messages: [],
        isLoadingMessages: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _webSocketService.dispose();
    return super.close();
>>>>>>> zoz
  }
}
