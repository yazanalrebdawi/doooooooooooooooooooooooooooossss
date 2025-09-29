import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/home_state.dart';
import 'home_title_widget.dart';
import 'chats_title_widget.dart';
import 'home_actions_widget.dart';
import 'chats_actions_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.1),
          title: state.currentIndex == 3 
              ? const ChatsTitleWidget()
              : const HomeTitleWidget(),
          actions: state.currentIndex == 3 
              ? const [ChatsActionsWidget()]
              : const [HomeActionsWidget()],
        );
      },
    );
  }



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 