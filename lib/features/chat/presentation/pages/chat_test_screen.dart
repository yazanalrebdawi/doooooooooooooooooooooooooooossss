import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/chat_cubit.dart';
import '../manager/chat_state.dart';

class ChatTestScreen extends StatefulWidget {
  const ChatTestScreen({super.key});

  @override
  State<ChatTestScreen> createState() => _ChatTestScreenState();
}

class _ChatTestScreenState extends State<ChatTestScreen> {
  final TextEditingController _dealerIdController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dealerIdController.text = '25'; // Default dealer ID
  }

  @override
  void dispose() {
    _dealerIdController.dispose();
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
          icon: Icon(Icons.arrow_back, color:isDark ? Colors.white :  AppColors.black, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chat System Test',
          style: AppTextStyles.blackS18W700.withThemeColor(context),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => di.sl<ChatCubit>(),
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Status:',
                          style: AppTextStyles.s16w600.copyWith(color:isDark ? Colors.white: AppColors.black),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: state.isWebSocketConnected ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'WebSocket: ${state.isWebSocketConnected ? 'Connected' : 'Disconnected'}',
                              style: AppTextStyles.s14w400.copyWith(
                                color: state.isWebSocketConnected ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Chats: ${state.chats.length}',
                          style: AppTextStyles.s14w400.copyWith(color: isDark ? Colors.white: AppColors.gray),
                        ),
                        if (state.selectedChatId != null)
                          Text(
                            'Selected Chat: ${state.selectedChatId}',
                            style: AppTextStyles.s14w400.copyWith(color: isDark ? Colors.white: AppColors.gray),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Create Chat Section
                  Text(
                    'Create New Chat:',
                    style: AppTextStyles.s16w600.copyWith(color: isDark?Colors.white : AppColors.black),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _dealerIdController,
                          decoration: InputDecoration(
                            hintText: 'Dealer ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: state.isCreatingChat
                            ? null
                            : () {
                                final dealerId = int.tryParse(_dealerIdController.text);
                                if (dealerId != null) {
                                  context.read<ChatCubit>().createChat(dealerId);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        ),
                        child: state.isCreatingChat
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                                                         : Text(
                                 'Create Chat',
                                 style: AppTextStyles.s16w600.copyWith(color: AppColors.white),
                               ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Send Message Section
                  if (state.isWebSocketConnected) ...[
                    Text(
                      'Send Message:',
                      style: AppTextStyles.s16w600.copyWith(color: isDark ? Colors.white :  AppColors.black),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: _messageController.text.trim().isEmpty
                              ? null
                              : () {
                                  context.read<ChatCubit>().sendMessageViaWebSocket(_messageController.text.trim());
                                  _messageController.clear();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          ),
                                                     child: Text(
                             'Send',
                             style: AppTextStyles.s16w600.copyWith(color: AppColors.white),
                           ),
                        ),
                      ],
                    ),
                  ],
                  
                  SizedBox(height: 24.h),
                  
                  // Chats List
                  Text(
                    'Chats List:',
                    style: AppTextStyles.s16w600.copyWith(color: isDark? Colors.white : AppColors.black),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: state.isLoading
                        ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : state.chats.isEmpty
                            ? Center(
                                child: Text(
                                  'No chats yet. Create a chat to get started.',
                                  style: AppTextStyles.s14w400.copyWith(color: isDark ? Colors.white: AppColors.gray),
                                ),
                              )
                            : ListView.builder(
                                itemCount: state.chats.length,
                                itemBuilder: (context, index) {
                                  final chat = state.chats[index];
                                  return Card(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    child: ListTile(
                                                                             title: Text(
                                         chat.dealer,
                                         style: AppTextStyles.s16w600,
                                       ),
                                      subtitle: Text(
                                        chat.lastMessage?.text ?? 'No messages',
                                        style: AppTextStyles.s12w400.copyWith(color: isDark ? Colors.white: AppColors.gray),
                                      ),
                                      trailing: chat.userUnreadCount > 0
                                          ? Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                '${chat.userUnreadCount}',
                                                style: AppTextStyles.s12w400.copyWith(color: AppColors.white),
                                              ),
                                            )
                                          : null,
                                      onTap: () {
                                        context.read<ChatCubit>().loadMessages(chat.id);
                                        context.go('/chat-conversation/${chat.id}');
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
