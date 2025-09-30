import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import 'package:dooss_business_app/features/chat/data/models/message_model.dart';
import 'package:dooss_business_app/features/chat/data/models/socket_message.dart';
import 'chat_state.dart';
import '../../data/data_source/chat_remote_data_source.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../core/services/token_service.dart';

class ChatCubit extends OptimizedCubit<ChatState> {
  final ChatRemoteDataSource dataSource;
  final WebSocketService _webSocketService = di.appLocator<WebSocketService>();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ChatCubit(this.dataSource) : super(const ChatState()) {
    print('ChatCubit - Initialized');
    _setupWebSocketCallbacks();
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) async {
      final hasInternet =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (hasInternet && state.selectedChatId != null) {
        if (!_webSocketService.isConnected && !_webSocketService.isConnecting) {
          final accessToken = await TokenService.getAccessToken();
          if (accessToken != null) {
            print('🌐 Internet back, reconnecting WebSocket...');
            await _webSocketService.connect(state.selectedChatId!, accessToken);
          }
        }
      }
    });
  }

  void _setupWebSocketCallbacks() {
    _webSocketService.onConnected = () {
      print('✅ ChatCubit: WebSocket connected');
      safeEmit(state.copyWith(isWebSocketConnected: true));
      _resendPendingMessages();
    };

    _webSocketService.onDisconnected = () {
      print('🔌 ChatCubit: WebSocket disconnected');
      safeEmit(state.copyWith(isWebSocketConnected: false));
    };

    _webSocketService.onMessageReceived = (message) {
      print('📨 ChatCubit: Message received via WebSocket: $message');
      _handleIncomingMessage(message);
    };

    _webSocketService.onError = (error) {
      print('❌ ChatCubit: WebSocket error: $error');
      safeEmit(state.copyWith(error: 'WebSocket error: $error'));
    };
  }

  void loadChats() async {
    print('ChatCubit - loadChats() called');
    safeEmit(state.copyWith(isLoading: true, error: null));
    try {
      final chats = await dataSource.fetchChats();
      safeEmit(state.copyWith(chats: chats, isLoading: false));
    } catch (e) {
      print('ChatCubit error: $e');
      safeEmit(state.copyWith(error: 'Failed to load chats', isLoading: false));
    }
  }

  void loadMessages(int chatId) async {
    print('ChatCubit - loadMessages() called with chatId: $chatId');
    safeEmit(
      state.copyWith(
        isLoadingMessages: true,
        error: null,
        selectedChatId: chatId,
      ),
    );
    try {
      final messages = await dataSource.fetchMessages(chatId);
      safeEmit(state.copyWith(messages: messages, isLoadingMessages: false));
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
    if (state.selectedChatId == null) return;

    try {
      final message = await dataSource.sendMessage(
        state.selectedChatId!,
        content,
      );
      final updatedMessages = [...state.messages, message];
      safeEmit(state.copyWith(messages: updatedMessages));
    } catch (e) {
      print('ChatCubit sendMessage error: $e');
      safeEmit(state.copyWith(error: 'Failed to send message'));
    }
  }

  void createChat(int dealerUserId) async {
    safeEmit(state.copyWith(isCreatingChat: true, error: null));
    try {
      final chat = await dataSource.createChat(dealerUserId);
      final updatedChats = [...state.chats, chat];
      safeEmit(
        state.copyWith(
          chats: updatedChats,
          selectedChatId: chat.id,
          isCreatingChat: false,
        ),
      );
      _connectToWebSocket(chat.id);
    } catch (e) {
      safeEmit(
        state.copyWith(
          error: 'Failed to create chat: $e',
          isCreatingChat: false,
        ),
      );
    }
  }

  void _connectToWebSocket(int chatId) async {
    final accessToken = await TokenService.getAccessToken();
    if (accessToken != null) {
      await _webSocketService.connect(chatId, accessToken);
    } else {
      safeEmit(state.copyWith(error: 'No access token found'));
    }
  }

  void _handleIncomingMessage(String message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic> &&
          decoded['type'] == 'chat.message') {
        final socketMessage = SocketMessageModel.fromJson(decoded);

        final updatedMessages =
            state.messages.map((m) {
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

        final alreadyUpdated = updatedMessages.any(
          (m) => m.id == socketMessage.messageId,
        );

        final finalMessages =
            alreadyUpdated
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
                    isMine: true,
                  ),
                ];

        finalMessages.sort(
          (a, b) => DateTime.parse(
            a.timestamp,
          ).compareTo(DateTime.parse(b.timestamp)),
        );

        safeEmit(state.copyWith(messages: finalMessages));
      }
    } catch (e) {
      print('ChatCubit: Error decoding message: $e');
    }
  }

  void sendMessageViaWebSocket(String text) {
    if (!state.isWebSocketConnected) {
      safeEmit(state.copyWith(error: 'Not connected to chat server'));
      return;
    }
    _webSocketService.sendMessage(text);
  }

  void disconnectWebSocket() {
    _webSocketService.disconnect();
  }

  void clearSelectedChat() {
    disconnectWebSocket();
    safeEmit(
      state.copyWith(
        selectedChatId: null,
        messages: [],
        isLoadingMessages: false,
      ),
    );
  }

  void sendMessageOfflineSafe(String text) async {
    String? id = await TokenService.getUserId();

    final tempMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      sender: "me",
      senderId: int.tryParse(id ?? '0') ?? 0,
      text: text,
      type: "text",
      status: "pending",
      timestamp: DateTime.now().toIso8601String(),
      isMine: true,
      fileUrl: '',
      imageUrl: '',
    );

    safeEmit(
      state.copyWith(
        messages: [...state.messages, tempMessage]..sort(
          (a, b) => DateTime.parse(
            a.timestamp,
          ).compareTo(DateTime.parse(b.timestamp)),
        ),
        pendingMessages: [...state.pendingMessages, tempMessage],
      ),
    );

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
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _webSocketService.dispose();
    return super.close();
  }
}
