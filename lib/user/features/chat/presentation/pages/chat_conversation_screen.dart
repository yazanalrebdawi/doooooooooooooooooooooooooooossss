import 'dart:developer';

import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart'
    as di;
import 'package:dooss_business_app/user/core/services/chat_id_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/chat_cubit.dart';
import '../manager/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_product_card.dart';

class ChatConversationScreen extends StatefulWidget {
  final int chatId;
  final String participantName;
  final int? productId; // Add product ID for displaying product details
  final String dealerName;
  const ChatConversationScreen({
    super.key,
    required this.chatId,
    required this.dealerName,
    required this.participantName,
    this.productId,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  String? id;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  int _lastMessageCount = 0;

  void getUserId() async {
    id = await TokenService.getUserId();
  }

  @override
  void initState() {
    super.initState();
    getUserId();

    // Load messages immediately after first frame - need context for BlocProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadMessages();
    });
  }

  void _loadMessages() {
    try {
      final cubit = context.read<ChatCubit>();
      print(
          'ChatConversationScreen - Loading messages for chat ${widget.chatId}');

      // Set global chat ID
      final chatIdService = di.appLocator<ChatIdService>();
      chatIdService.setChatId(widget.chatId);
      print('✅ ChatConversationScreen - Set global chat ID: ${widget.chatId}');

      // Load messages when entering the screen
      cubit.loadMessages(widget.chatId);

      // Connect WebSocket if not already connected for this chat
      if (!cubit.state.isWebSocketConnected) {
        print(
            'ChatConversationScreen - Connecting WebSocket for chat ${widget.chatId}');
        cubit.connectWebSocket(widget.chatId);
      } else if (cubit.state.selectedChatId != widget.chatId) {
        // If WebSocket is connected but for a different chat, reconnect for this chat
        print(
            'ChatConversationScreen - Reconnecting WebSocket for chat ${widget.chatId}');
        cubit.connectWebSocket(widget.chatId);
      }
    } catch (e) {
      print('❌ ChatConversationScreen - Error loading messages: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isDark ? Colors.white : AppColors.black, size: 24.sp),
              onPressed: () {
                context.pop();
                log("pop🫠🫠🫠🫠🫠🫠🫠");
              }),
        title: Text(
          widget.dealerName,
          style: AppTextStyles.blackS18W700,
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert,
        //         color: isDark ? Colors.white : AppColors.black, size: 24.sp),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) {
          // Mark as read when messages finish loading
          final messagesJustLoaded = previous.isLoadingMessages && !current.isLoadingMessages;
          final hasMessages = current.messages.isNotEmpty;
          final newMessageReceived = current.messages.length > previous.messages.length;
          
          // Also listen for new messages to ensure UI updates
          if (newMessageReceived) {
            print('📨 ChatConversationScreen - New message received! Previous: ${previous.messages.length}, Current: ${current.messages.length}');
          }
          
          return messagesJustLoaded && hasMessages;
        },
        listener: (context, state) {
          // Mark all messages as read when messages are loaded
          print('ChatConversationScreen - Marking all messages as read for chat ${widget.chatId}');
          final cubit = context.read<ChatCubit>();
          cubit.markMessagesAsRead(widget.chatId, []);
        },
        child: Column(
          children: [
            // Product Card (if productId is provided)
            if (widget.productId != null)
              ChatProductCard(productId: widget.productId!),

            // Messages List
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) {
                  // Always rebuild when messages change, selectedChatId changes, or loading state changes
                  final messagesChanged = previous.messages.length != current.messages.length ||
                      previous.messages.map((m) => m.id).join(',') != current.messages.map((m) => m.id).join(',');
                  final chatChanged = previous.selectedChatId != current.selectedChatId;
                  final loadingChanged = previous.isLoadingMessages != current.isLoadingMessages;
                  final errorChanged = previous.error != current.error;
                  
                  if (messagesChanged) {
                    print('🔄 ChatConversationScreen - Messages changed: ${previous.messages.length} -> ${current.messages.length}');
                  }
                  
                  return messagesChanged || chatChanged || loadingChanged || errorChanged;
                },
                builder: (context, state) {
                  if (state.isLoadingMessages) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: isDark ? Colors.white : AppColors.gray,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            AppLocalizations.of(context)
                                    ?.translate('errorLoadingMessages') ??
                                'Error loading messages',
                            style: AppTextStyles.s16w500.copyWith(
                              color: isDark ? Colors.white : AppColors.gray,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            AppLocalizations.of(context)
                                    ?.translate(state.error ?? '') ??
                                state.error!,
                            style: AppTextStyles.s14w400.copyWith(
                              color: isDark ? Colors.white : AppColors.gray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Only show empty state if not loading and messages are truly empty
                  if (state.messages.isEmpty && !state.isLoadingMessages) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 64.sp, color: AppColors.gray),
                          SizedBox(height: 16.h),
                          Text(
                            AppLocalizations.of(context)
                                    ?.translate('noMessagesYet') ??
                                'No messages yet',
                            style: AppTextStyles.s16w500.copyWith(
                              color: isDark ? Colors.white : AppColors.gray,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Start a conversation with ${widget.participantName}',
                            style: AppTextStyles.s14w400.copyWith(
                              color: isDark ? Colors.white : AppColors.gray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Scroll to bottom when messages count changes or when a new message arrives
                  if (state.messages.length != _lastMessageCount) {
                    _lastMessageCount = state.messages.length;
                    print('📜 ChatConversationScreen - Message count changed to ${state.messages.length}, scrolling to bottom');
                    // Use multiple callbacks to ensure scroll happens
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) _scrollToBottom();
                    });
                  }

                return ListView.builder(
                  controller: _scrollController, // attach scroll controller

                  padding: EdgeInsets.all(16.w),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    // ULTRA SIMPLE: If message.isMine is true, use it. Period.
                    // Only use senderId fallback if isMine is explicitly false AND we have valid userId
                    final currentUserId = int.tryParse(id ?? '0') ?? 0;
                    final isMine = message.isMine ||
                        (message.senderId != 0 &&
                            currentUserId != 0 &&
                            id != null &&
                            message.senderId == currentUserId);

                    // Debug log for pending messages
                    if (message.status.toLowerCase() == 'pending') {
                      print(
                          '🎯 Rendering pending message: id=${message.id}, text="${message.text}", isMine=$isMine, message.isMine=${message.isMine}, senderId=${message.senderId}, currentUserId=$currentUserId');
                    }

                    return MessageBubble(
                      message: message,
                      isMine: isMine,
                      onRetry: message.status.toLowerCase() == 'pending'
                          ? () {
                              context
                                  .read<ChatCubit>()
                                  .connectWebSocket(widget.chatId);
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ),

          // Chat Input
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, chatState) {
              return ChatInputField(
                controller: _messageController,
                onSendMessage: (message) {
                  if (message.trim().isNotEmpty) {
                    // Use WebSocket if connected, otherwise fallback to API
                    context
                        .read<ChatCubit>()
                        .sendMessageOfflineSafe(message.trim());
                    _messageController.clear();
                  }
                },
              );
            },
          ),
        ],
        ),
      ),
    );
  }
}
