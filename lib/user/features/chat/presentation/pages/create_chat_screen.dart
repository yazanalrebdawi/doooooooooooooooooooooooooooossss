import 'package:dooss_business_app/user/core/services/token_service.dart';
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

class CreateChatScreen extends StatefulWidget {
  final int dealerId;
  final String dealerName;
  final int? productId;

  const CreateChatScreen({
    super.key,
    required this.dealerId,
    required this.dealerName,
    this.productId,
  });

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  String? id;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  int _lastMessageCount = 0;

  void getUserId() async {
    id = await TokenService.getUserId();
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
  void initState() {
    super.initState();
    getUserId();
    // Create chat automatically when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.dealerId > 0) {
        print(
            'CreateChatScreen: Creating chat with dealerId: ${widget.dealerId}');
        context.read<ChatCubit>().createChat(widget.dealerId);
      } else {
        print('CreateChatScreen: Invalid dealerId: ${widget.dealerId}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.translate('unableToCreateChat') ??
                  'Unable to create chat: Invalid dealer ID',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.dealerName,
          style: AppTextStyles.blackS18W700,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Navigate to full chat screen when chat is created and WebSocket is connected
          if (state.selectedChatId != null && state.isWebSocketConnected) {
            // Close the create chat screen first
            Navigator.of(context).pop();
            // Navigate to full chat conversation screen with dealer name and product ID
            context.push('/chat/${state.selectedChatId}', extra: {
              'dealerName': widget.dealerName,
              'productId': widget.productId,
            });
          }
        },
        builder: (context, state) {
          if (state.isCreatingChat) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)?.translate('creatingChat') ??
                        'Creating chat...',
                    style: AppTextStyles.s16w500.copyWith(
                        color: isDark ? Colors.white : AppColors.gray),
                  ),
                ],
              ),
            );
          }

          return Column(
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
                                      .connectWebSocket(state.selectedChatId!);
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
          );
        },
      ),
    );
  }
}
