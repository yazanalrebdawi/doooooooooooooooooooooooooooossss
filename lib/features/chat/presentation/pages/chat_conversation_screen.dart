import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../features/home/presentaion/manager/product_cubit.dart';
import '../../../../features/home/presentaion/manager/product_state.dart';
import '../manager/chat_cubit.dart';
import '../manager/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_product_card.dart';
import '../../../../core/services/token_service.dart';

class ChatConversationScreen extends StatefulWidget {
  final int chatId;
  final String participantName;
  final int? productId; 
  final String dealerName;

  const ChatConversationScreen({
    super.key,
    required this.chatId,
    required this.participantName,
    required this.dealerName,
    this.productId,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  String? userId;
  final ScrollController _scrollController = ScrollController();

  void _getUserId() async {
    userId = await TokenService.getUserId();
    setState(() {}); // لتحديث الـ UI بعد جلب الـ userId
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => di.sl<ChatCubit>()
        ..loadMessages(widget.chatId)
        ..connectWebSocket(widget.chatId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : AppColors.black, size: 24.sp),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.dealerName,
            style: AppTextStyles.blackS18W700.withThemeColor(context),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Product Card
            if (widget.productId != null)
              ChatProductCard(productId: widget.productId!),

            // Messages List
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) =>
                    previous.messages != current.messages ||
                    previous.isLoadingMessages != current.isLoadingMessages ||
                    previous.error != current.error,
                builder: (context, state) {
                  if (state.isLoadingMessages) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64.sp, color: AppColors.gray),
                          SizedBox(height: 16.h),
                          Text(
                            'Error loading messages',
                            style: AppTextStyles.s16w500.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            state.error!,
                            style: AppTextStyles.s14w400.copyWith(
                              color: AppColors.gray,
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
                            'No messages yet',
                            style: AppTextStyles.s16w500.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Start a conversation with ${widget.participantName}',
                            style: AppTextStyles.s14w400.copyWith(
                              color: AppColors.gray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(
                        message: message,
                        isMine:
                            message.senderId == int.tryParse(userId ?? '0'),
                        onRetry: message.status.toLowerCase() == 'pending'
                            ? () => context
                                .read<ChatCubit>()
                                .connectWebSocket(widget.chatId)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),

            // Chat Input
            BlocBuilder<ChatCubit, ChatState>(
              buildWhen: (previous, current) =>
                  previous.isWebSocketConnected != current.isWebSocketConnected,
              builder: (context, chatState) {
                return ChatInputField(
                  controller: TextEditingController(),
                  onSendMessage: (message) {
                    if (message.trim().isEmpty) return;

                    if (chatState.isWebSocketConnected) {
                      context
                          .read<ChatCubit>()
                          .sendMessageViaWebSocket(message.trim());
                    } else {
                      context
                          .read<ChatCubit>()
                          .sendMessageOfflineSafe(message.trim());
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
