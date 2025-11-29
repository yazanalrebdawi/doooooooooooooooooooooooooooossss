import 'dart:async';
import 'package:dooss_business_app/user/core/cubits/optimized_cubit.dart';
import 'package:dooss_business_app/user/features/chat/data/models/message_model.dart';
import 'package:dooss_business_app/user/features/chat/data/models/socket_message.dart';
import 'package:dooss_business_app/user/features/chat/data/models/chat_model.dart';
import 'chat_state.dart';
import '../../data/data_source/chat_remote_data_source.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../core/services/token_service.dart';
import '../../../../core/services/storage/secure_storage/secure_storage_service.dart';
import '../../../../core/services/storage/shared_preferances/shared_preferences_service.dart';
import '../../../../core/services/chat_id_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class ChatCubit extends OptimizedCubit<ChatState> {
  final ChatRemoteDataSource dataSource;
  final WebSocketService _webSocketService = di.appLocator<WebSocketService>();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

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
          // getAccessToken() now handles both regular users and dealers
          final accessToken = await TokenService.getAccessToken();

          if (accessToken != null && accessToken.isNotEmpty) {
            print('🌐 Internet back, reconnecting WebSocket...');
            await _webSocketService.connect(state.selectedChatId!, accessToken);
            safeEmit(state.copyWith(isWebSocketConnected: true));
            // ❌ No _resendPendingMessages() here anymore
          } else {
            print(
                '⚠️ Internet back but no access token found for WebSocket reconnection');
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

    _webSocketService.onMessageReceived = (data) {
      print('📨 ChatCubit: Message received via WebSocket: $data');
      _handleIncomingMessage(data); // pass the map directly
    };

    _webSocketService.onError = (error) {
      print('❌ ChatCubit: WebSocket error: $error');
      safeEmit(state.copyWith(error: 'WebSocket error: $error'));
    };
  }

  Future<void> loadChats() async {
    if (state.isLoading) return;
    
    safeEmit(state.copyWith(isLoading: true, error: null));
    try {
      final chats = await dataSource.fetchChats();
      safeEmit(state.copyWith(chats: chats, isLoading: false));
    } catch (e) {
      safeEmit(state.copyWith(error: 'Failed to load chats', isLoading: false));
    }
  }

  void loadMessages(int chatId) async {
    if (state.selectedChatId == chatId && state.messages.isNotEmpty) {
      return;
    }

    if (state.selectedChatId != null && state.selectedChatId != chatId) {
      safeEmit(state.copyWith(messages: [], pendingMessages: []));
    }

    final chatIdService = di.appLocator<ChatIdService>();
    chatIdService.setChatId(chatId);

    safeEmit(
      state.copyWith(
        isLoadingMessages: true,
        error: null,
        selectedChatId: chatId,
      ),
    );
    try {
      final apiMessages = await dataSource.fetchMessages(chatId);
      final apiMessageIds = apiMessages.map((m) => m.id).toSet();
      final pendingNotInApi = state.pendingMessages
          .where((p) => !apiMessageIds.contains(p.id))
          .toList();

      final mergedMessages = [...apiMessages, ...pendingNotInApi];
      mergedMessages.sort(
        (a, b) =>
            DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)),
      );

      safeEmit(
        state.copyWith(
          messages: mergedMessages,
          selectedChatId: chatId,
          isLoadingMessages: false,
        ),
      );

      if (state.chats.isEmpty) {
        await loadChats();
      }

      // Check if there are unread messages in the chat
      final currentChat = state.chats.firstWhere(
        (chat) => chat.id == chatId,
        orElse: () => ChatModel(
          id: chatId,
          user: '',
          dealer: '',
          createdAt: '',
          userUnreadCount: 0,
          dealerUnreadCount: 0,
        ),
      );

      // Check if current user is a dealer to determine which unread count to check
      final secureStorage = di.appLocator<SecureStorageService>();
      final sharedPrefsService = di.appLocator<SharedPreferencesService>();
      bool isDealer = await secureStorage.getIsDealer();
      if (!isDealer) {
        final dealerData = await sharedPrefsService.getDealerAuthData();
        isDealer = dealerData != null;
      }

      final unreadCount = isDealer
          ? currentChat.dealerUnreadCount
          : currentChat.userUnreadCount;

      print(
          '🔵 ChatCubit - loadMessages: Chat $chatId has $unreadCount unread messages (isDealer: $isDealer)');

      // Only mark messages as read if there are unread messages
      if (unreadCount > 0) {
        // Try sending an empty list to mark ALL unread messages
        // The API comment says "empty list is valid" - this might mark all unread messages
        print(
            '🔵 ChatCubit - loadMessages: Sending empty list to mark ALL $unreadCount unread messages (API will mark all unread messages)');
        _markMessagesAsRead(chatId, []);
      } else {
        print(
            'ℹ️ ChatCubit - No unread messages (unreadCount: $unreadCount), skipping mark as read');
      }
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

  // Public method to mark messages as read (can be called from UI)
  void markMessagesAsRead(int chatId, List<int> messageIds) {
    _markMessagesAsRead(chatId, messageIds);
  }

  void _markMessagesAsRead(int chatId, List<int> messageIds) async {
    try {
      print(
          '🔵 ChatCubit - _markMessagesAsRead called for chat: $chatId with ${messageIds.length} message IDs');
      print('🔵 ChatCubit - Current chats in state: ${state.chats.length}');

      // ALWAYS load chat list first to ensure we have it
      if (state.chats.isEmpty) {
        print('⚠️ ChatCubit - Chat list is empty, loading chats first');
        await loadChats();
      }

      // Check if current user is a dealer
      final secureStorage = di.appLocator<SecureStorageService>();
      final sharedPrefsService = di.appLocator<SharedPreferencesService>();
      bool isDealer = await secureStorage.getIsDealer();
      if (!isDealer) {
        final dealerData = await sharedPrefsService.getDealerAuthData();
        isDealer = dealerData != null;
      }
      print('🔵 ChatCubit - Current user is dealer: $isDealer');

      // Filter out temporary pending message IDs (very large numbers from timestamps)
      // Real message IDs are small integers (< 1 billion), pending IDs are timestamps (> 1 billion)
      final messageIdsToSend =
          messageIds.where((id) => id > 0 && id < 1000000000).toList();

      // Empty list is valid - it might mark ALL unread messages
      // Only skip if we had message IDs but they were all invalid (filtered out)
      if (messageIds.isNotEmpty && messageIdsToSend.isEmpty) {
        print(
            '⚠️ ChatCubit - No valid message IDs to send after filtering, skipping API call');
        print('⚠️ ChatCubit - Original message IDs: $messageIds');
        return;
      }
      // If messageIds is empty, we're intentionally sending empty list to mark all unread

      print(
          '🔵 ChatCubit - Filtered message IDs: ${messageIds.length} -> ${messageIdsToSend.length} (removed ${messageIds.length - messageIdsToSend.length} temporary IDs)');
      print(
          '🔵 ChatCubit - Sending ${messageIdsToSend.length} message IDs (dealer: $isDealer)');

      // ALWAYS call API - no conditions, just call it
      print(
          '🔵 ChatCubit - Calling API to mark messages as read (dealer: $isDealer, messageIds: ${messageIdsToSend.length})');
      Map<String, dynamic>? apiResponse;
      apiResponse =
          await dataSource.markMessagesAsRead(chatId, messageIdsToSend);
      print('🔵 ChatCubit - API call completed. Response: $apiResponse');

      if (apiResponse == null) {
        print('⚠️ ChatCubit - API call returned null');
        return;
      }

      int? newDealerUnreadCount = apiResponse['dealer_unread_count'] as int?;
      int? newUserUnreadCount = apiResponse['user_unread_count'] as int?;

      if (newDealerUnreadCount != null || newUserUnreadCount != null) {
        final updatedChats = List<ChatModel>.from(
          state.chats.map((chat) {
            if (chat.id == chatId) {
              return chat.copyWith(
                dealerUnreadCount: newDealerUnreadCount ?? chat.dealerUnreadCount,
                userUnreadCount: newUserUnreadCount ?? chat.userUnreadCount,
              );
            }
            return chat;
          })
        );
        safeEmit(state.copyWith(chats: updatedChats));
      }
    } catch (e, stackTrace) {
      print('❌ ChatCubit - Error marking messages as read: $e');
      print('❌ Stack trace: $stackTrace');
      // Don't emit error, this is not critical
    }
  }

  void sendMessage(String content, int id) async {
    print('ChatCubit - sendMessage() called with content: $content');
    if (state.selectedChatId == null) {
      print('ChatCubit - No selectedChatId, cannot send message');
      return;
    }

    try {
      print('ChatCubit - Calling dataSource.sendMessage()');
      final message = await dataSource.sendMessage(
        state.selectedChatId!,
        content,
      );
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
      // Set global chat ID
      final chatIdService = di.appLocator<ChatIdService>();
      chatIdService.setChatId(chat.id);

      safeEmit(
        state.copyWith(
          chats: updatedChats,
          selectedChatId: chat.id,
          isCreatingChat: false,
        ),
      );

      // Connect to WebSocket
      _connectToWebSocket(chat.id);
    } catch (e) {
      print('ChatCubit createChat error: $e');
      safeEmit(
        state.copyWith(
          error: 'Failed to create chat: $e',
          isCreatingChat: false,
        ),
      );
    }
  }

  void _connectToWebSocket(int chatId) async {
    // getAccessToken() now handles both regular users and dealers
    final accessToken = await TokenService.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      print('✅ ChatCubit: Connecting to WebSocket with token');
      await _webSocketService.connect(chatId, accessToken);
      safeEmit(state.copyWith(isWebSocketConnected: true));
    } else {
      print('❌ ChatCubit: No access token found, cannot connect to WebSocket');
      safeEmit(state.copyWith(error: 'No access token found'));
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> decoded) async {
    try {
      if (decoded['type'] == 'chat.message') {
        final socketMessage = SocketMessageModel.fromJson(decoded);

        // Get current user ID
        String? currentUserIdString = await TokenService.getUserId();
        if (currentUserIdString == null) {
          final secureStorage = di.appLocator<SecureStorageService>();
          final sharedPrefsService = di.appLocator<SharedPreferencesService>();
          bool isDealer = await secureStorage.getIsDealer();
          if (isDealer) {
            final dealerData = await sharedPrefsService.getDealerAuthData();
            if (dealerData != null) {
              currentUserIdString = dealerData.user.id.toString();
            }
          }
        }
        
        final currentUserId = int.tryParse(currentUserIdString ?? '0') ?? 0;
        final isMine = socketMessage.sender == currentUserId;

        // Check if message already exists
        final existingIndex = state.messages.indexWhere(
          (m) => m.id == socketMessage.messageId,
        );

        if (existingIndex != -1) {
          // Update existing message status
          final existingMessage = state.messages[existingIndex];
          if (existingMessage.status != socketMessage.status) {
            final updatedMessages = List<MessageModel>.from(state.messages);
            updatedMessages[existingIndex] = existingMessage.copyWith(
              status: socketMessage.status,
            );
            print('📨 ChatCubit - Updating existing message status: ID=${existingMessage.id}, status=${existingMessage.status} -> ${socketMessage.status}');
            safeEmit(state.copyWith(messages: updatedMessages));
            print('✅ ChatCubit - State emitted with updated message status');
          }
          return;
        }

        // Try to match with pending message
        if (isMine) {
          final pendingIndex = state.messages.indexWhere(
            (m) => m.status.toLowerCase() == 'pending' &&
                m.text.trim() == socketMessage.text.trim(),
          );

          if (pendingIndex != -1) {
            // Update pending message
            final pendingMessage = state.messages[pendingIndex];
            final updatedMessages = List<MessageModel>.from(state.messages);
            updatedMessages[pendingIndex] = MessageModel(
              id: socketMessage.messageId,
              senderId: socketMessage.sender,
              sender: socketMessage.sender.toString(),
              text: socketMessage.text,
              type: socketMessage.messageType,
              status: socketMessage.status,
              imageUrl: socketMessage.imageUrl,
              fileUrl: socketMessage.fileUrl,
              fileSize: socketMessage.fileSize?.toString(),
              timestamp: socketMessage.timestamp,
              isMine: true,
            );

            // Remove from pending messages list
            final updatedPendingMessages = List<MessageModel>.from(
              state.pendingMessages.where((m) => m.id != pendingMessage.id)
            );

            updatedMessages.sort(
              (a, b) => DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)),
            );

            print('📨 ChatCubit - Updating pending message: ID=${pendingMessage.id} -> ${socketMessage.messageId}, status=pending -> ${socketMessage.status}');
            print('📨 ChatCubit - Total messages after update: ${updatedMessages.length}');
            
            safeEmit(state.copyWith(
              messages: updatedMessages,
              pendingMessages: updatedPendingMessages,
            ));
            
            print('✅ ChatCubit - State emitted with updated message. Current message count: ${state.messages.length}');
            return;
          }
        }

        // Add new message (either from other party, or from current user but no pending match found)
        final newMessage = MessageModel(
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
          isMine: isMine,
        );

        final finalMessages = List<MessageModel>.from([...state.messages, newMessage]);
        finalMessages.sort(
          (a, b) => DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)),
        );

        print('📨 ChatCubit - Adding new message via WebSocket: ID=${newMessage.id}, text="${newMessage.text}", isMine=$isMine');
        print('📨 ChatCubit - Total messages after adding: ${finalMessages.length}');
        
        // Create a completely new list to ensure state change is detected
        safeEmit(state.copyWith(messages: finalMessages));
        
        print('✅ ChatCubit - State emitted with new message. Current message count: ${state.messages.length}');
      }
    } catch (e) {
      print('ChatCubit: Error handling incoming message: $e');
    }
  }

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
    // Clear global chat ID
    final chatIdService = di.appLocator<ChatIdService>();
    chatIdService.clearChatId();

    safeEmit(
      state.copyWith(
        selectedChatId: null,
        messages: [],
        isLoadingMessages: false,
      ),
    );
  }

  /// Reset chat state completely (used on logout)
  void resetChatState() {
    print('🔄 ChatCubit - resetChatState() called - Resetting all chat data');
    disconnectWebSocket();
    // Clear global chat ID
    final chatIdService = di.appLocator<ChatIdService>();
    chatIdService.clearChatId();

    // Reset to initial state - clear all chats, messages, and unread counts
    safeEmit(const ChatState());
    print('✅ ChatCubit - Chat state reset successfully');
  }

  connectWebSocket(int chatId) => _connectToWebSocket(chatId);

  void sendMessageOfflineSafe(String text) async {
    print('📤 ChatCubit - sendMessageOfflineSafe called with text: "$text"');
    print('📤 ChatCubit - WebSocket connected: ${state.isWebSocketConnected}');
    print('📤 ChatCubit - Selected chat ID: ${state.selectedChatId}');

    String? id = await TokenService.getUserId();

    // If user ID is null, try to get it from dealer auth data
    if (id == null) {
      print('⚠️ ChatCubit - User ID is null, checking dealer auth data...');
      final secureStorage = di.appLocator<SecureStorageService>();
      final sharedPrefsService = di.appLocator<SharedPreferencesService>();
      bool isDealer = await secureStorage.getIsDealer();
      if (isDealer) {
        final dealerData = await sharedPrefsService.getDealerAuthData();
        if (dealerData != null) {
          id = dealerData.user.id.toString();
          print('✅ ChatCubit - Found dealer user ID: $id');
        }
      }
    }

    print('📤 ChatCubit - User ID: $id');

    // Check if chat is selected - if not, try to get it from global service
    int? chatId = state.selectedChatId;
    if (chatId == null) {
      final chatIdService = di.appLocator<ChatIdService>();
      chatId = chatIdService.currentChatId;
      if (chatId != null) {
        print('✅ ChatCubit - Using global chat ID: $chatId');
        // Update state with the global chat ID
        safeEmit(state.copyWith(selectedChatId: chatId));
      }
    }

    if (chatId == null) {
      print(
          '❌ ChatCubit - No selectedChatId and no global chat ID, cannot send message');
      safeEmit(state.copyWith(
          error: 'No chat selected. Please select a chat first.'));
      return;
    }

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
      imageUrl: '',
    );

    print(
        '📤 ChatCubit - Created temp message: id=${tempMessage.id}, text="${tempMessage.text}", senderId=${tempMessage.senderId}');

    // Show message immediately
    safeEmit(
      state.copyWith(
        messages: [...state.messages, tempMessage] // append at end
          ..sort(
            (a, b) => DateTime.parse(
              a.timestamp,
            ).compareTo(DateTime.parse(b.timestamp)),
          ),
        pendingMessages: [...state.pendingMessages, tempMessage],
      ),
    );

    // Try to send via WebSocket if connected
    if (state.isWebSocketConnected || _webSocketService.isConnected) {
      print(
          '📤 ChatCubit - WebSocket is connected, attempting to send message');
      // Update state if WebSocket service is connected but state doesn't reflect it
      if (!state.isWebSocketConnected && _webSocketService.isConnected) {
        safeEmit(state.copyWith(isWebSocketConnected: true));
      }
      _tryResend(tempMessage);
    } else {
      print(
          '⚠️ ChatCubit - WebSocket not connected, message will be pending. Attempting to connect...');
      // Try to connect WebSocket (chatId is guaranteed to be non-null at this point)
      print('🔄 ChatCubit - Attempting to connect WebSocket for chat $chatId');
      _connectToWebSocket(chatId);
      // Wait a bit for connection to establish, then try to send
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_webSocketService.isConnected) {
          print('✅ ChatCubit - WebSocket connected, sending message');
          safeEmit(state.copyWith(isWebSocketConnected: true));
          _tryResend(tempMessage);
        } else {
          print(
              '⚠️ ChatCubit - WebSocket connection failed, message will remain pending');
        }
      });
    }
  }

  void _resendPendingMessages() {
    print('🔄 ChatCubit - _resendPendingMessages called');
    print(
        '🔄 ChatCubit - State isWebSocketConnected: ${state.isWebSocketConnected}');
    print(
        '🔄 ChatCubit - WebSocket service isConnected: ${_webSocketService.isConnected}');
    print(
        '🔄 ChatCubit - Pending messages count: ${state.pendingMessages.length}');

    // Check both state and actual WebSocket service connection
    if (!state.isWebSocketConnected && !_webSocketService.isConnected) {
      print(
          '⚠️ ChatCubit - WebSocket not connected, cannot resend pending messages');
      return;
    }

    // Update state if WebSocket service is connected but state isn't
    if (_webSocketService.isConnected && !state.isWebSocketConnected) {
      print('🔄 ChatCubit - Updating state to reflect WebSocket connection');
      safeEmit(state.copyWith(isWebSocketConnected: true));
    }

    for (var msg in state.pendingMessages) {
      print(
          '🔄 ChatCubit - Resending pending message: id=${msg.id}, text="${msg.text}"');
      _tryResend(msg);
    }
  }

  void _tryResend(MessageModel msg) {
    try {
      print(
          '🔄 ChatCubit - _tryResend called for message: id=${msg.id}, text="${msg.text}"');
      print(
          '🔄 ChatCubit - WebSocket service connected: ${_webSocketService.isConnected}');
      if (_webSocketService.isConnected) {
        _webSocketService.sendMessage(msg.text);
        print('✅ ChatCubit - Message sent via WebSocket: "${msg.text}"');
      } else {
        print(
            '❌ ChatCubit - WebSocket service not connected, cannot send message');
      }
      // do NOT remove from pending yet; wait for server confirmation
    } catch (e) {
      print('❌ ChatCubit - Error in _tryResend: $e');
    }
  }
}
