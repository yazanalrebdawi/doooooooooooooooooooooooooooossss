import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../manager/chat_cubit.dart';
import '../manager/chat_state.dart';
import '../widgets/chat_list_item.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  void initState() {
    super.initState();
    // Load chats when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) =>
          previous.chats != current.chats ||
          previous.isLoading != current.isLoading ||
          previous.error != current.error,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 40.sp,
                    color: AppColors.gray,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Error loading chats',
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
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<ChatCubit>().loadChats();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: 40.sp,
                    color: AppColors.gray,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No chats yet',
                  style: AppTextStyles.s16w500.copyWith(
                    color: isDark ? Colors.white : AppColors.gray,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start a conversation',
                  style: AppTextStyles.s14w400.copyWith(
                    color: isDark ? Colors.white : AppColors.gray,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<ChatCubit>().loadChats();
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: state.chats.length,
          itemBuilder: (context, index) {
            final chat = state.chats[index];
            return ChatListItem(
              chat: chat,
              onTap: () {
                context.go('/chat/${chat.id}');
              },
            );
          },
        );
      },
    );
  }
}
