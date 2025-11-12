import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart'
    as di;
import 'package:dooss_business_app/user/core/services/chat_id_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/chat_cubit.dart';
import '../manager/chat_state.dart';
import 'message_bubble.dart';
import 'chat_input_field.dart';
import 'chat_product_card.dart';

class ChatBottomSheet extends StatefulWidget {
  final int chatId;
  final String dealerName;
  final int? productId;
  final ChatCubit chatCubit;

  const ChatBottomSheet({
    super.key,
    required this.chatId,
    required this.dealerName,
    required this.chatCubit,
    this.productId,
  });

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  String? id;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _getUserId();
    _initializeChat();
  }

  void _getUserId() async {
    id = await TokenService.getUserId();
  }

  void _initializeChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = widget.chatCubit;
      // Set global chat ID
      final chatIdService = di.appLocator<ChatIdService>();
      chatIdService.setChatId(widget.chatId);
      print('✅ ChatBottomSheet - Set global chat ID: ${widget.chatId}');

      // Ensure selectedChatId is set for this chat
      if (cubit.state.selectedChatId != widget.chatId) {
        // Load messages which will also set selectedChatId
        cubit.loadMessages(widget.chatId);
        // Wait a bit for loadMessages to complete and set selectedChatId
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // Connect WebSocket if not already connected for this chat
      if (!cubit.state.isWebSocketConnected) {
        cubit.connectWebSocket(widget.chatId);
      }
    });
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
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - keyboardHeight;
    final maxHeight = screenHeight * 0.85;
    final containerHeight = keyboardHeight > 0
        ? availableHeight.clamp(screenHeight * 0.5, screenHeight)
        : maxHeight;

    return BlocProvider.value(
      value: widget.chatCubit,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? Colors.white : AppColors.black,
              size: 24.sp,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.dealerName,
            style: AppTextStyles.blackS18W700,
          ),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        ),
        body: Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Product Card (if productId is provided)
              if (widget.productId != null)
                ChatProductCard(productId: widget.productId!),

              // Messages List
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state.isLoading) {
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

                    if (state.messages.isEmpty) {
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
                              AppLocalizations.of(context)
                                      ?.translate('startConversation') ??
                                  'Start a conversation',
                              style: AppTextStyles.s14w400.copyWith(
                                color: isDark ? Colors.white : AppColors.gray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Only scroll to bottom when messages count changes
                    if (state.messages.length != _lastMessageCount) {
                      _lastMessageCount = state.messages.length;
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollToBottom());
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final currentUserId = int.tryParse(id ?? '0') ?? 0;
                        final isMine = message.isMine ||
                            (message.senderId != 0 &&
                                currentUserId != 0 &&
                                id != null &&
                                message.senderId == currentUserId);

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
      ),
    );
  }
}
