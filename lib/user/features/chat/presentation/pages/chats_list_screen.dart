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

class _ChatsListScreenState extends State<ChatsListScreen> with WidgetsBindingObserver {
  int _forceRebuildCounter = 0; // Counter to force rebuild
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load chats when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadChats();
    });
  }
  
  void _forceSetState() {
    if (mounted) {
      _forceRebuildCounter++; // Increment counter to force rebuild
      print('🔄 ChatsListScreen - FORCING setState directly (bypassing state management), counter: $_forceRebuildCounter');
      setState(() {
        // Force rebuild by changing counter
        _forceRebuildCounter = _forceRebuildCounter;
      });
      // Force multiple setState calls to ensure it sticks
      Future.microtask(() {
        if (mounted) {
          _forceRebuildCounter++;
          setState(() {});
        }
      });
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) {
          _forceRebuildCounter++;
          setState(() {});
        }
      });
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _forceRebuildCounter++;
          setState(() {});
        }
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _forceRebuildCounter++;
          setState(() {});
        }
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _forceRebuildCounter++;
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Force refresh when app resumes
      _forceRefresh();
    }
  }

  void _forceRefresh() {
    if (mounted) {
      print('🔄 ChatsListScreen - Force refreshing chat list');
      context.read<ChatCubit>().loadChats();
      setState(() {});
    }
  }

  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refresh if we've already initialized (to avoid double loading on first build)
    if (_hasInitialized) {
      // Force refresh every time the screen is entered (when dependencies change)
      // This ensures unread counts are updated when popping back from chat
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          print('🔄 ChatsListScreen - Screen re-entered, calling API to refresh chat list');
          final cubit = context.read<ChatCubit>();
          // Force API call to get fresh data
          print('📡 ChatsListScreen - Calling loadChats()');
          await cubit.loadChats();
          print('✅ ChatsListScreen - API call completed');
          // FORCE setState multiple times after API call
          _forceSetState();
        }
      });
    } else {
      _hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (previous, current) {
        // Always listen to all state changes
        return true;
      },
      listener: (context, state) {
        // CRITICAL: Force rebuild IMMEDIATELY when state changes
        print('🔄 ChatsListScreen - Chat state changed, forcing rebuild with setState');
        print('📊 ChatsListScreen - Current state: ${state.chats.length} chats, isLoading: ${state.isLoading}');
        // Force setState multiple times to ensure UI updates
        if (mounted) {
          _forceSetState();
        }
      },
      child: Builder(
        key: ValueKey('force_rebuild_$_forceRebuildCounter'),
        builder: (context) {
          // CRITICAL: Force read state directly from cubit instead of relying on BlocBuilder
          final cubit = context.read<ChatCubit>();
          final state = cubit.state;
          
          print(
              'ChatsListScreen - BUILDING: isLoading=${state.isLoading}, chatsCount=${state.chats.length}, error=${state.error}, forceRebuildCounter=$_forceRebuildCounter');

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
        // Debug: Print unread counts for all chats
        for (var chat in state.chats) {
          print(
              'ChatsListScreen - Chat ${chat.id} (${chat.dealer}): userUnreadCount = ${chat.userUnreadCount}, dealerUnreadCount = ${chat.dealerUnreadCount}');
        }
        
        // CRITICAL: Create a unique key that changes with force rebuild counter to force rebuild
        final listKey = ValueKey('chats_list_${_forceRebuildCounter}_${state.chats.length}_${state.chats.map((c) => '${c.id}_${c.userUnreadCount}_${c.dealerUnreadCount}').join('_')}');
        
        return Scaffold(
          key: ValueKey('scaffold_$_forceRebuildCounter'),
          body: ListView.builder(
            key: listKey,
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              print(
                  'ChatsListScreen - Building chat item: ${chat.dealer}, unreadCount: ${chat.userUnreadCount}, dealerUnread: ${chat.dealerUnreadCount}, forceCounter: $_forceRebuildCounter');
              // CRITICAL: Create unique key with force rebuild counter to force rebuild
              return ChatListItem(
                key: ValueKey('chat_${_forceRebuildCounter}_${chat.id}_${chat.userUnreadCount}_${chat.dealerUnreadCount}'),
                chat: chat,
                onTap: () {
                  print('ChatsListScreen - Tapped on chat: ${chat.dealer}');
                  context.push('/chat/${chat.id}', extra: chat.dealer);
                },
              );
            },
          ),
        );
        },
      ),
    );
  }
}
