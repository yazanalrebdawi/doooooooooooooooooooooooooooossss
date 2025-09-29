import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
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
      builder: (context, state) {
        print(
            'ChatsListScreen - State: isLoading=${state.isLoading}, chatsCount=${state.chats.length}, error=${state.error}');

        if (state.isLoading) {
          print('ChatsListScreen - Showing loading indicator');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.error != null) {
          print('ChatsListScreen - Showing error: ${state.error}');
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
                  style: AppTextStyles.s16w500
                      .copyWith(color: isDark ? Colors.white : AppColors.gray),
                ),
                SizedBox(height: 8.h),
                Text(
                  state.error!,
                  style: AppTextStyles.s14w400
                      .copyWith(color: isDark ? Colors.white : AppColors.gray),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    print('ChatsListScreen - Retrying to load chats');
                    context.read<ChatCubit>().loadChats();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.chats.isEmpty) {
          print('ChatsListScreen - Showing empty state');
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
                  style: AppTextStyles.s16w500
                      .copyWith(color: isDark ? Colors.white : AppColors.gray),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start a conversation',
                  style: AppTextStyles.s14w400
                      .copyWith(color: isDark ? Colors.white : AppColors.gray),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    print('ChatsListScreen - Manually loading chats');
                    context.read<ChatCubit>().loadChats();
                  },
                  child: Text(
                    'Refresh',
                    style: AppTextStyles.blackS14W700.copyWith(
                        color: isDark ? Colors.white : AppColors.gray),
                  ),
                ),
              ],
            ),
          );
        }

        print('ChatsListScreen - Showing ${state.chats.length} chats');
        return ListView.builder(
          itemCount: state.chats.length,
          itemBuilder: (context, index) {
            final chat = state.chats[index];
            print('ChatsListScreen - Building chat item: ${chat.dealer}');
            return ChatListItem(
              chat: chat,
              onTap: () {
                print('ChatsListScreen - Tapped on chat: ${chat.dealer}');
                context.push('/chat/${chat.id}', extra: chat.dealer);
              },
            );
          },
        );
      },
    );
  }
}
