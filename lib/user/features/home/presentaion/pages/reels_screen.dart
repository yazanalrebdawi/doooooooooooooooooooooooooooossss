import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/reel_cubit.dart';
import '../widgets/reels_screen_content.dart';

class ReelsScreen extends StatelessWidget {
  final int? initialReelId;

  const ReelsScreen({super.key, this.initialReelId});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return BlocProvider(
      create: (_) => di.appLocator<ReelCubit>()..loadReels(),
      child: WillPopScope(
        onWillPop: () async {
          // Prevent popping - user must use bottom navigation to navigate away
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: ReelsScreenContent(
            pageController: pageController,
            initialReelId: initialReelId,
          ),
        ),
      ),
    );
  }
}
