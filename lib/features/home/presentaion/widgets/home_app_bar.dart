import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
=======
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
>>>>>>> zoz
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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // allow theme scaffold to show
          shadowColor: Colors.black.withOpacity(0.1),
          iconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
          title: state.currentIndex == 3
              ? const ChatsTitleWidget()
              : const HomeTitleWidget(),
          actions: state.currentIndex == 3
=======
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
>>>>>>> zoz
              ? const [ChatsActionsWidget()]
              : const [HomeActionsWidget()],
        );
      },
    );
  }

<<<<<<< HEAD
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
=======


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 
>>>>>>> zoz
