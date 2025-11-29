import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_state.dart';
import 'home_title_widget.dart';
import 'chats_title_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // شفاف ليتوافق مع الثيم
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
          actions: null, // Removed chat actions (search and three dots icons)
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
