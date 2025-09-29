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

class ChatConversationScreen extends StatelessWidget {
  final int chatId;
  final String participantName;
  final int? productId; // Add product ID for displaying product details

  const ChatConversationScreen({
    super.key,
    required this.chatId,
    required this.participantName,
    this.productId,
  });

  @override
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
        ),
        body: Column(
          children: [
            // Product Card (if productId is provided)
            if (productId != null) ChatProductCard(productId: productId!),

            // Messages List
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) {
                  return previous.messages != current.messages ||
                      previous.isLoadingMessages != current.isLoadingMessages ||
                      previous.error != current.error;
                },

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
                            color: AppColors.gray,
                          ),
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
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64.sp,
                            color: AppColors.gray,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No messages yet',
                            style: AppTextStyles.s16w500.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Start a conversation with $participantName',
                            style: AppTextStyles.s14w400.copyWith(
                              color: AppColors.gray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(message: message);
                    },
                  );
                },
              ),
            ),

            // Chat Input
            BlocBuilder<ChatCubit, ChatState>(
              buildWhen: (previous, current) {
                return previous.isWebSocketConnected !=
                    current.isWebSocketConnected;
              },

              builder: (context, chatState) {
                return ChatInputField(
                  controller: TextEditingController(),
                  onSendMessage: (message) {
                    if (message.trim().isNotEmpty) {
                      // Use WebSocket if connected, otherwise fallback to API
                      if (chatState.isWebSocketConnected) {
                        context.read<ChatCubit>().sendMessageViaWebSocket(
                          message.trim(),
                        );
                      } else {
                        context.read<ChatCubit>().sendMessage(message.trim());
                      }
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
