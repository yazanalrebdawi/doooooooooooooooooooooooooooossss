import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/home_app_bar.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/home_bottom_navigation.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/home_tab_selector.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_state.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreenInitializer();
  }
}

class HomeScreenInitializer extends StatelessWidget {
  const HomeScreenInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(GoRouterState.of(context).uri.toString());
    final tabParam = uri.queryParameters['tab'];

    // لتحديث الـ tab عند وجود query parameter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tabParam == 'messages') {
        context.read<HomeCubit>().updateCurrentIndex(3);
      }
    });

    return const HomeScreenLayout();
  }
}

class HomeScreenLayout extends StatelessWidget {
  const HomeScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, int>(
      selector: (state) => state.currentIndex,
      builder: (context, currentIndex) {
        return Scaffold(
          // إخفاء الـ AppBar عند tab معين (مثلاً index 2)
          appBar: currentIndex == 2 ? null : const HomeAppBar(),
          body: const HomeScreenBody(),
        );
      },
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(child: HomeTabSelector()),
        HomeBottomNavigationWrapper(),
      ],
    );
  }
}

class HomeBottomNavigationWrapper extends StatelessWidget {
  const HomeBottomNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, homeState) {
        // إخفاء الـ BottomNavigation عند tab محدد (مثلاً index 2)
        if (homeState.currentIndex == 2) {
          return const SizedBox.shrink();
        }
        return HomeBottomNavigation(
          currentIndex: homeState.currentIndex,
          onTap: (index) => context.read<HomeCubit>().updateCurrentIndex(index),
        );
      },
    );
  }
}
