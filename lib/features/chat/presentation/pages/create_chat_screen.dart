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
<<<<<<< HEAD
              final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white :AppColors.black, size: 24.sp),
=======
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
>>>>>>> zoz
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chat with ${widget.dealerName}',
<<<<<<< HEAD
          style: AppTextStyles.blackS18W700.withThemeColor(context),
=======
          style: AppTextStyles.blackS18W700,
>>>>>>> zoz
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
<<<<<<< HEAD
=======
        listenWhen: (previous, current) {
          return previous.error != current.error ||
              previous.selectedChatId != current.selectedChatId;
        },
>>>>>>> zoz
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
<<<<<<< HEAD
          
=======

>>>>>>> zoz
          // Navigate to chat conversation when chat is created
          if (state.selectedChatId != null && state.isWebSocketConnected) {
            context.go('/chat-conversation/${state.selectedChatId}');
          }
        },
<<<<<<< HEAD
=======
        buildWhen: (previous, current) {
          return previous.isCreatingChat != current.isCreatingChat ||
              previous.isWebSocketConnected != current.isWebSocketConnected;
        },
>>>>>>> zoz
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
<<<<<<< HEAD
                    style: AppTextStyles.s16w500.copyWith(color: isDark?Colors.white: AppColors.gray),
=======
                    style: AppTextStyles.s16w500.copyWith(
                      color: AppColors.gray,
                    ),
>>>>>>> zoz
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
<<<<<<< HEAD
                  style: AppTextStyles.s16w500.copyWith(color:isDark ? Colors.white: AppColors.gray),
=======
                  style: AppTextStyles.s16w500.copyWith(color: AppColors.gray),
>>>>>>> zoz
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.dealerName,
<<<<<<< HEAD
                  style: AppTextStyles.blackS18W700.withThemeColor(context),
=======
                  style: AppTextStyles.blackS18W700,
>>>>>>> zoz
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                Text(
                  'Type your first message:',
<<<<<<< HEAD
                  style: AppTextStyles.s14w400.copyWith(color: isDark ? Colors.white: AppColors.gray),
=======
                  style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
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
<<<<<<< HEAD
                    onPressed: state.isWebSocketConnected && _messageController.text.trim().isNotEmpty
                        ? () {
                            context.read<ChatCubit>().sendMessageViaWebSocket(_messageController.text.trim());
                            _messageController.clear();
                          }
                        : null,
=======
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
>>>>>>> zoz
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Send Message',
<<<<<<< HEAD
                      style: AppTextStyles.s16w600.copyWith(color: AppColors.white),
=======
                      style: AppTextStyles.s16w600.copyWith(
                        color: AppColors.white,
                      ),
>>>>>>> zoz
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
