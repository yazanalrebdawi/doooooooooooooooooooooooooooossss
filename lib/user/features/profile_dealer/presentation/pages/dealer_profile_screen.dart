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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });

    // Load dealer profile data and reels on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DealerProfileCubit>().loadDealerProfile(widget.dealerId);
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
      appBar: DealerProfileAppBar(dealerHandle: widget.dealerHandle),
      body: BlocBuilder<DealerProfileCubit, DealerProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
                  Text('Error loading profile',
                      style: AppTextStyles.s16w500
                          .copyWith(color: AppColors.gray)),
                  SizedBox(height: 8.h),
                  Text(
                    state.error!,
                    style:
                        AppTextStyles.s14w400.copyWith(color: AppColors.gray),
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
              // Profile Header
              DealerProfileHeader(
                dealer: state.dealer,
                onMessagePressed: () {
                  if (state.dealer != null) {
                    print('💬 DealerProfile: Message button pressed');
                    print('💬 DealerProfile: dealer.id = ${state.dealer!.id}');
                    print(
                        '💬 DealerProfile: dealer.userId = ${state.dealer!.userId}');

                    // Use user_id instead of dealer profile id for creating chats
                    final dealerUserId = state.dealer!.userId;

                    if (dealerUserId != null && dealerUserId > 0) {
                      print(
                          '💬 DealerProfile: Creating chat with dealer user ID: $dealerUserId');
                      // Navigate to create chat with dealer user ID
                      context.push('/create-chat', extra: {
                        'dealerId': dealerUserId,
                        'dealerName': state.dealer!.name,
                      });
                    } else {
                      print(
                          '❌ DealerProfile: Invalid dealer user ID: ${state.dealer!.userId}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Unable to start chat: Invalid dealer user ID'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              // Tabs
              DealerProfileTabs(
                tabController: _tabController,
                currentIndex: _currentTabIndex,
                onTabChanged: (index) {
                  _tabController.animateTo(index);
                  // Load data for selected tab
                  switch (index) {
                    case 0:
                      context
                          .read<DealerProfileCubit>()
                          .loadReels(widget.dealerId);
                      break;
                    case 1:
                      context
                          .read<DealerProfileCubit>()
                          .loadCars(widget.dealerId);
                      break;
                  }
                },
              ),
              // Content area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    DealerContentGrid(
                      contentType: ContentType.reels,
                      content: state.reels,
                      isLoading: state.isLoadingReels,
                    ),
                    DealerContentGrid(
                      contentType: ContentType.cars,
                      content: state.cars,
                      isLoading: state.isLoadingCars,
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
