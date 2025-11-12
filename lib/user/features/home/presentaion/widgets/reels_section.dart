import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/empty_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/full_screen_reel_player.dart';
import 'package:dooss_business_app/user/features/home/data/models/reel_model.dart';

class ReelsSection extends StatefulWidget {
  final List<ReelModel> reels;
  final VoidCallback? onViewAllPressed;
  final VoidCallback? onReelPressed;

  const ReelsSection({
    super.key,
    required this.reels,
    this.onViewAllPressed,
    this.onReelPressed,
  });

  @override
  State<ReelsSection> createState() => _ReelsSectionState();
}

class _ReelsSectionState extends State<ReelsSection> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Set full-screen immersive mode for reels
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore system UI when leaving reels
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reels.isEmpty) {
      return const EmptySection(message: 'No reels available');
    }

    // Full-screen vertical PageView for reels
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Main vertical PageView
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: widget.reels.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final reel = widget.reels[index];
              final isCurrentReel = index == _currentIndex;

              return FullScreenReelPlayer(
                key: Key('reel_${reel.id}'),
                reel: reel,
                isCurrentReel: isCurrentReel,
                onTap: () => print('Tapped reel ${reel.id}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
