import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:flutter_screenutil/flutter_screenutil.dart';
=======
>>>>>>> zoz
import '../../../../core/services/native_video_service.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/reel_cubit.dart';
import '../widgets/reels_screen_content.dart';

class ReelsScreen extends StatelessWidget {
  final int? initialReelId;
<<<<<<< HEAD
  
  const ReelsScreen({
    super.key,
    this.initialReelId,
  });
=======
  const ReelsScreen({super.key, this.initialReelId});
>>>>>>> zoz

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
<<<<<<< HEAD
    
    return BlocProvider(
      create: (_) => di.sl<ReelCubit>()..loadReels(),
=======

    return BlocProvider(
      create: (_) => di.appLocator<ReelCubit>()..loadReels(),
      // ignore: deprecated_member_use
>>>>>>> zoz
      child: WillPopScope(
        onWillPop: () async {
          // Clean up video resources before navigating back
          await NativeVideoService.dispose();
          return true;
        },
        child: Scaffold(
<<<<<<< HEAD
=======
          //? هون معروض مع التاب بار
          backgroundColor: Colors.black,
>>>>>>> zoz
          body: ReelsScreenContent(
            pageController: pageController,
            initialReelId: initialReelId,
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> zoz
