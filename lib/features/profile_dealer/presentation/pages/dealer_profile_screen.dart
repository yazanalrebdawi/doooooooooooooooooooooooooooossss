import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../manager/dealer_profile_cubit.dart';
import '../manager/dealer_profile_state.dart';
import '../widgets/dealer_profile_app_bar.dart';
import '../widgets/dealer_profile_header.dart';
import '../widgets/dealer_profile_tabs.dart';
import '../widgets/dealer_content_grid.dart';
import '../../data/models/content_type.dart';

class DealerProfileScreen extends StatefulWidget {
  final String dealerId;
  final String dealerHandle;

  const DealerProfileScreen({
    super.key,
    required this.dealerId,
    required this.dealerHandle,
  });

  @override
  State<DealerProfileScreen> createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });

    // Load dealer profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DealerProfileCubit>().loadDealerProfile(widget.dealerId);
        // تحميل الريلز تلقائياً عند بداية التطبيق
        context.read<DealerProfileCubit>().loadReels(widget.dealerId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: DealerProfileAppBar(
        dealerHandle: widget.dealerHandle,
      ),
      body: BlocBuilder<DealerProfileCubit, DealerProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: AppColors.gray,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading profile',
                    style: AppTextStyles.s16w500.copyWith(color: AppColors.gray),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.error!,
                    style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  
                  if (state.error!.contains('تسجيل الدخول')) ...[
                    ElevatedButton(
                      onPressed: () {
                        context.go(RouteNames.loginScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ],
                ],
              ),
            );
          }

          return Column(
            children: [
              // Profile Header Section
              DealerProfileHeader(
                dealer: state.dealer,
                onFollowPressed: () {
                  context.read<DealerProfileCubit>().toggleFollow();
                },
                onMessagePressed: () {
                  // Navigate to chat
                  context.push('/chat-conversation/${state.dealer?.id}');
                },
              ),

              // Tabs Section
              DealerProfileTabs(
                tabController: _tabController,
                currentIndex: _currentTabIndex,
                onTabChanged: (index) {
                  _tabController.animateTo(index);
                  // تحميل البيانات الحقيقية حسب التاب المحدد
                  switch (index) {
                    case 0: // Reels
                      context.read<DealerProfileCubit>().loadReels(widget.dealerId);
                      break;
                    case 1: // Cars
                      context.read<DealerProfileCubit>().loadCars(widget.dealerId);
                      break;
                    case 2: // Services
                      context.read<DealerProfileCubit>().loadServices(widget.dealerId);
                      break;
                  }
                },
              ),

              // Content Section
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Reels Tab
                    DealerContentGrid(
                      contentType: ContentType.reels,
                      content: state.reels,
                      isLoading: state.isLoadingReels,
                    ),
                    // Cars Tab
                    DealerContentGrid(
                      contentType: ContentType.cars,
                      content: state.cars,
                      isLoading: state.isLoadingCars,
                    ),
                    // Services Tab
                    DealerContentGrid(
                      contentType: ContentType.services,
                      content: state.services,
                      isLoading: state.isLoadingServices,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }


}
