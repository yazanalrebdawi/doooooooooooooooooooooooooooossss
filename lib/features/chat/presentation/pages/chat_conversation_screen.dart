<<<<<<< HEAD
import 'package:dooss_business_app/core/services/token_service.dart';
=======
>>>>>>> zoz
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

<<<<<<< HEAD
class ChatConversationScreen extends StatefulWidget {
  final int chatId;
  final String participantName;
  final int? productId; // Add product ID for displaying product details
final String dealerName ;
  const ChatConversationScreen({
    super.key,
    required this.chatId,required this.dealerName ,
=======
class ChatConversationScreen extends StatelessWidget {
  final int chatId;
  final String participantName;
  final int? productId; // Add product ID for displaying product details

  const ChatConversationScreen({
    super.key,
    required this.chatId,
>>>>>>> zoz
    required this.participantName,
    this.productId,
  });

  @override
<<<<<<< HEAD
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  String? id;
  final ScrollController _scrollController = ScrollController();

  void getUserId() async {
    id = await TokenService.getUserId();
  }

  @override
  void initState() {
    getUserId();
    super.initState();
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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.more_vert,
          //         color: isDark ? Colors.white : AppColors.black, size: 24.sp),
          //     onPressed: () {},
          //   ),
          // ],
=======
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.appLocator<ChatCubit>()..loadMessages(chatId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
            onPressed: () => context.go('/home?tab=messages'),
          ),
          title: Text(participantName, style: AppTextStyles.blackS18W700),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: AppColors.black, size: 24.sp),
              onPressed: () {},
            ),
          ],
>>>>>>> zoz
        ),
        body: Column(
          children: [
            // Product Card (if productId is provided)
<<<<<<< HEAD
            if (widget.productId != null)
              ChatProductCard(productId: widget.productId!),
=======
            if (productId != null) ChatProductCard(productId: productId!),
>>>>>>> zoz

            // Messages List
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
<<<<<<< HEAD
=======
                buildWhen: (previous, current) {
                  return previous.messages != current.messages ||
                      previous.isLoadingMessages != current.isLoadingMessages ||
                      previous.error != current.error;
                },

>>>>>>> zoz
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
<<<<<<< HEAD
                            color: isDark ? Colors.white : AppColors.gray,
=======
                            color: AppColors.gray,
>>>>>>> zoz
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Error loading messages',
                            style: AppTextStyles.s16w500.copyWith(
<<<<<<< HEAD
                              color: isDark ? Colors.white : AppColors.gray,
=======
                              color: AppColors.gray,
>>>>>>> zoz
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            state.error!,
                            style: AppTextStyles.s14w400.copyWith(
<<<<<<< HEAD
                              color: isDark ? Colors.white : AppColors.gray,
=======
                              color: AppColors.gray,
>>>>>>> zoz
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
<<<<<<< HEAD
                          Icon(Icons.chat_bubble_outline,
                              size: 64.sp, color: AppColors.gray),
=======
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64.sp,
                            color: AppColors.gray,
                          ),
>>>>>>> zoz
                          SizedBox(height: 16.h),
                          Text(
                            'No messages yet',
                            style: AppTextStyles.s16w500.copyWith(
<<<<<<< HEAD
                              color: isDark ? Colors.white : AppColors.gray,
=======
                              color: AppColors.gray,
>>>>>>> zoz
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
<<<<<<< HEAD
                            'Start a conversation with ${widget.participantName}',
                            style: AppTextStyles.s14w400.copyWith(
                              color: isDark ? Colors.white : AppColors.gray,
=======
                            'Start a conversation with $participantName',
                            style: AppTextStyles.s14w400.copyWith(
                              color: AppColors.gray,
>>>>>>> zoz
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
<<<<<<< HEAD
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController, // attach scroll controller

=======

                  return ListView.builder(
>>>>>>> zoz
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
<<<<<<< HEAD
                      print(message.senderId);
                      return MessageBubble(
                        message: message,
                        isMine: message.senderId == int.tryParse(id ?? '0'),
                        onRetry: message.status.toLowerCase() == 'pending'
                            ? () {
                                context
                                    .read<ChatCubit>()
                                    .connectWebSocket(widget.chatId);
                              }
                            : null,
                      );
=======
                      return MessageBubble(message: message);
>>>>>>> zoz
                    },
                  );
                },
              ),
            ),

            // Chat Input
            BlocBuilder<ChatCubit, ChatState>(
<<<<<<< HEAD
=======
              buildWhen: (previous, current) {
                return previous.isWebSocketConnected !=
                    current.isWebSocketConnected;
              },

>>>>>>> zoz
              builder: (context, chatState) {
                return ChatInputField(
                  controller: TextEditingController(),
                  onSendMessage: (message) {
                    if (message.trim().isNotEmpty) {
                      // Use WebSocket if connected, otherwise fallback to API
<<<<<<< HEAD

                      context
                          .read<ChatCubit>()
                          .sendMessageOfflineSafe(message.trim());
=======
                      if (chatState.isWebSocketConnected) {
                        context.read<ChatCubit>().sendMessageViaWebSocket(
                          message.trim(),
                        );
                      } else {
                        context.read<ChatCubit>().sendMessage(message.trim());
                      }
>>>>>>> zoz
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
