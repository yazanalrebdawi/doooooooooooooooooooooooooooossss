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
    print('ChatCubit - loadChats() called');
    safeEmit(state.copyWith(isLoading: true, error: null));
    try {
      print('ChatCubit - Calling dataSource.fetchChats()');
      final chats = await dataSource.fetchChats();
      print('ChatCubit - Received ${chats.length} chats from dataSource');
      safeEmit(state.copyWith(chats: chats, isLoading: false));
      print('ChatCubit - State updated with ${state.chats.length} chats');
    } catch (e) {
      print('ChatCubit error: $e');
      safeEmit(state.copyWith(error: 'Failed to load chats', isLoading: false));
    }
  }

  void loadMessages(int chatId, {bool forceRefresh = false}) async {
    print(
        'ChatCubit - loadMessages() called with chatId: $chatId, forceRefresh: $forceRefresh');

    // Prevent duplicate loads if messages are already loaded for this chat and not forcing refresh
    // But always allow load if it's a different chat or if messages are empty
    if (!forceRefresh &&
        state.selectedChatId == chatId &&
        state.messages.isNotEmpty &&
        !state.isLoadingMessages) {
      // Check if messages are actually for this chat (not from a previous chat)
      // If all messages have valid IDs (not pending), assume they're for this chat
      final hasRealMessages =
          state.messages.any((m) => m.id > 0 && m.id < 1000000000);
      if (hasRealMessages) {
        print(
            '⚠️ ChatCubit - Messages already loaded for chat $chatId, skipping duplicate load');
        return;
      }
    }

    // If switching to a different chat, clear old messages first
    if (state.selectedChatId != null && state.selectedChatId != chatId) {
      print(
          '🔄 ChatCubit - Switching from chat ${state.selectedChatId} to $chatId, clearing old messages');
      safeEmit(state.copyWith(messages: [], pendingMessages: []));
    }

    // Set global chat ID
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
      print('ChatCubit - Calling dataSource.fetchMessages()');
      final apiMessages = await dataSource.fetchMessages(chatId);
      print(
          'ChatCubit - Received ${apiMessages.length} messages from dataSource');

      // Merge API messages with pending messages
      // Pending messages should be preserved and updated with API data if they match
      final apiMessageIds = apiMessages.map((m) => m.id).toSet();

      // Keep pending messages that aren't in API yet (not confirmed)
      final pendingNotInApi = state.pendingMessages
          .where((p) => !apiMessageIds.contains(p.id))
          .toList();

      // Combine API messages with pending messages not yet confirmed
      final mergedMessages = [...apiMessages, ...pendingNotInApi];

      // Sort by timestamp
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
      print(
          'ChatCubit - State updated with ${state.messages.length} messages (${apiMessages.length} from API, ${pendingNotInApi.length} pending)');

      // Mark all unread messages as read after loading
      // First, ensure chat list is loaded to check unread count
      if (state.chats.isEmpty) {
        print(
            '🔵 ChatCubit - loadMessages: Chat list is empty, loading chats first');
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

      // Extract counts from API response for immediate update
      int? newDealerUnreadCount = apiResponse['dealer_unread_count'] as int?;
      int? newUserUnreadCount = apiResponse['user_unread_count'] as int?;
      print(
          '🔵 ChatCubit - API returned: dealer_unread_count=$newDealerUnreadCount, user_unread_count=$newUserUnreadCount');

      // Update the chat in the list immediately with API response values
      if (newDealerUnreadCount != null || newUserUnreadCount != null) {
        print(
            '🔵 ChatCubit - Updating chat list. Current chats: ${state.chats.map((c) => '${c.id}(u:${c.userUnreadCount},d:${c.dealerUnreadCount})').join(', ')}');

        final updatedChats = state.chats.map((chat) {
          if (chat.id == chatId) {
            print(
                '🔵 ChatCubit - Found chat ${chat.id}: updating from API response');
            return chat.copyWith(
              dealerUnreadCount: newDealerUnreadCount ?? chat.dealerUnreadCount,
              userUnreadCount: newUserUnreadCount ?? chat.userUnreadCount,
            );
          }
          return chat;
        }).toList();

        print(
            '🔵 ChatCubit - Updated chats: ${updatedChats.map((c) => '${c.id}(u:${c.userUnreadCount},d:${c.dealerUnreadCount})').join(', ')}');

        safeEmit(state.copyWith(chats: updatedChats));
        print('✅ ChatCubit - State updated immediately with API response');
      }

      // Only refresh chat list if we don't have chats or if counts don't match
      // This prevents unnecessary rebuilds and performance issues
      if (state.chats.isEmpty) {
        print(
            '🔄 ChatCubit - Chat list is empty, refreshing to get updated counts');
        await loadChats();
      } else {
        // Update the chat in the list with the API response values (already done above)
        // No need to refresh the entire list, we already updated it
        print('✅ ChatCubit - Chat list updated locally, skipping full refresh');
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

        // Get current user ID to determine if message is from current user
        final currentUserIdString = await TokenService.getUserId();
        final currentUserId = int.tryParse(currentUserIdString ?? '0') ?? 0;
        final isFromCurrentUser = socketMessage.sender == currentUserId;

        print(
            '📨 WebSocket message received: ID=${socketMessage.messageId}, sender=${socketMessage.sender}, currentUser=$currentUserId, isMine=$isFromCurrentUser, text="${socketMessage.text}"');
        print(
            '📋 Current messages count: ${state.messages.length}, pending: ${state.pendingMessages.length}');
        print(
            '📋 Pending messages: ${state.pendingMessages.map((p) => 'id=${p.id}, text="${p.text}", senderId=${p.senderId}, isMine=${p.isMine}').join(', ')}');

        // First check if message with this ID already exists (deduplication)
        final existingMessageIndex = state.messages.indexWhere(
          (m) => m.id == socketMessage.messageId,
        );

        if (existingMessageIndex != -1) {
          // Message already exists (probably loaded from API), just update its status if needed
          final existingMessage = state.messages[existingMessageIndex];
          // Only update isMine if we have a valid currentUserId, otherwise preserve existing value
          final shouldUpdateIsMine =
              currentUserId != 0 && existingMessage.isMine != isFromCurrentUser;
          final newIsMine =
              currentUserId != 0 ? isFromCurrentUser : existingMessage.isMine;

          if (existingMessage.status != socketMessage.status ||
              shouldUpdateIsMine) {
            final updatedMessages = List<MessageModel>.from(state.messages);
            updatedMessages[existingMessageIndex] = existingMessage.copyWith(
              status: socketMessage.status,
              isMine: newIsMine,
            );

            // Also remove any pending messages with the same text (cleanup duplicates)
            final updatedPendingMessages = state.pendingMessages
                .where((m) =>
                    m.text.trim() != socketMessage.text.trim() ||
                    m.senderId != socketMessage.sender)
                .toList();

            safeEmit(state.copyWith(
              messages: updatedMessages,
              pendingMessages: updatedPendingMessages,
            ));
          }
          return;
        }

        // Try to find and update a pending message
        // Match by text + timestamp (ignore senderId because it might be 0 in pending message)
        MessageModel? matchedPendingMessage;
        int matchedPendingIndex = -1;

        try {
          final socketTimestamp = DateTime.parse(socketMessage.timestamp);

          // Find the most recent pending message with matching text
          // We match by text + timestamp, NOT by senderId (because pending message might have senderId=0)
          MessageModel? closestMatch;
          int closestIndex = -1;
          Duration closestTimeDiff = const Duration(days: 1);

          for (int i = 0; i < state.messages.length; i++) {
            final m = state.messages[i];
            final isPending = m.status.toLowerCase() == 'pending';
            final isSameText = m.text.trim() == socketMessage.text.trim();

            if (isPending && isSameText) {
              final messageTimestamp = DateTime.parse(m.timestamp);
              final timeDiff =
                  socketTimestamp.difference(messageTimestamp).abs();

              // Match if pending, same text, and timestamps are within 30 seconds
              // Keep the closest match
              if (timeDiff.inSeconds <= 30 && timeDiff < closestTimeDiff) {
                closestMatch = m;
                closestIndex = i;
                closestTimeDiff = timeDiff;
              }
            }
          }

          if (closestMatch != null && closestIndex != -1) {
            matchedPendingMessage = closestMatch;
            matchedPendingIndex = closestIndex;
            print(
                '✅ Matched pending message by text+timestamp (${closestTimeDiff.inSeconds}s): pendingSenderId=${closestMatch.senderId}, socketSender=${socketMessage.sender}');
          } else {
            print(
                '⚠️ No pending message matched for text="${socketMessage.text}"');
          }
        } catch (e) {
          print('Error matching pending message: $e');
        }

        if (matchedPendingMessage != null && matchedPendingIndex != -1) {
          // Update the pending message with server response
          // CRITICAL: If we matched a pending message, it means:
          // 1. The text matches (same message content)
          // 2. The senderId matches (same user sent it)
          // 3. It was pending (just sent by current user)
          // Therefore, this message is ALWAYS from the current user, so isMine MUST be TRUE

          final updatedMessages = List<MessageModel>.from(state.messages);
          // Create new message - ALWAYS set isMine to TRUE because if it was pending, it's from current user
          updatedMessages[matchedPendingIndex] = MessageModel(
            id: socketMessage.messageId,
            senderId: socketMessage.sender,
            sender: socketMessage.sender.toString(),
            text: matchedPendingMessage.text,
            type: socketMessage.messageType,
            status: socketMessage.status,
            imageUrl: socketMessage.imageUrl,
            fileUrl: socketMessage.fileUrl,
            fileSize: socketMessage.fileSize?.toString(),
            timestamp: socketMessage.timestamp,
            isMine:
                true, // ALWAYS TRUE - if it was pending, it's from current user
          );

          print(
              '✅ Updated pending message: PRESERVED isMine=${matchedPendingMessage.isMine}, currentUserId=$currentUserId, sender=${socketMessage.sender}, pendingSenderId=${matchedPendingMessage.senderId}');

          // Remove from pending messages list
          final updatedPendingMessages = state.pendingMessages
              .where((m) => m.id != matchedPendingMessage!.id)
              .toList();

          updatedMessages.sort(
            (a, b) => DateTime.parse(a.timestamp)
                .compareTo(DateTime.parse(b.timestamp)),
          );

          safeEmit(state.copyWith(
            messages: updatedMessages,
            pendingMessages: updatedPendingMessages,
          ));
        } else {
          // If message is from current user but no pending message matched,
          // ignore it to prevent duplicates (it was already added via sendMessageOfflineSafe)
          // Check if it's from current user:
          // 1. isFromCurrentUser is true (valid currentUserId)
          // 2. OR if currentUserId is 0 but we have ANY pending messages (they're all from current user)
          // 3. OR if we have pending messages with same text (probably the same message)
          final hasPendingMessages = state.pendingMessages.isNotEmpty;
          final hasPendingWithSameText = state.pendingMessages
              .any((p) => p.text.trim() == socketMessage.text.trim());

          final mightBeFromCurrentUser = isFromCurrentUser ||
              (currentUserId == 0 &&
                  (hasPendingMessages || hasPendingWithSameText));

          if (mightBeFromCurrentUser) {
            print(
                '⚠️ Received WebSocket echo from current user (sender=${socketMessage.sender}), but no pending message matched. Has pending: $hasPendingMessages, same text: $hasPendingWithSameText. Ignoring to prevent duplicate.');
            return;
          }

          // New message from other user (not matching any pending message)
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
            isMine: false, // Always false for messages from other users
          );

          final finalMessages = [...state.messages, newMessage];
          finalMessages.sort(
            (a, b) => DateTime.parse(a.timestamp)
                .compareTo(DateTime.parse(b.timestamp)),
          );

          safeEmit(state.copyWith(messages: finalMessages));
        }
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
