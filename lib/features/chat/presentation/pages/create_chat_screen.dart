import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/chat_cubit.dart';
import '../manager/chat_state.dart';

class CreateChatScreen extends StatefulWidget {
  final int dealerId;
  final String dealerName;

  const CreateChatScreen({
    super.key,
    required this.dealerId,
    required this.dealerName,
  });

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Create chat automatically when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().createChat(widget.dealerId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chat with ${widget.dealerName}',
          style: AppTextStyles.blackS18W700,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listenWhen: (previous, current) {
          return previous.error != current.error ||
              previous.selectedChatId != current.selectedChatId;
        },
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Navigate to chat conversation when chat is created
          if (state.selectedChatId != null && state.isWebSocketConnected) {
            context.go('/chat-conversation/${state.selectedChatId}');
          }
        },
        buildWhen: (previous, current) {
          return previous.isCreatingChat != current.isCreatingChat ||
              previous.isWebSocketConnected != current.isWebSocketConnected;
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
                    'Creating chat...',
                    style: AppTextStyles.s16w500.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Starting conversation with',
                  style: AppTextStyles.s16w500.copyWith(color: AppColors.gray),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.dealerName,
                  style: AppTextStyles.blackS18W700,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                Text(
                  'Type your first message:',
                  style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Enter your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state.isWebSocketConnected &&
                                _messageController.text.trim().isNotEmpty
                            ? () {
                              context.read<ChatCubit>().sendMessageViaWebSocket(
                                _messageController.text.trim(),
                              );
                              _messageController.clear();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Send Message',
                      style: AppTextStyles.s16w600.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
