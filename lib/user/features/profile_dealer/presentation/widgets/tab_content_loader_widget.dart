import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/dealer_profile_cubit.dart';

class TabContentLoaderWidget extends StatelessWidget {
  final int tabIndex;
  final String dealerId;

  const TabContentLoaderWidget({
    super.key,
    required this.tabIndex,
    required this.dealerId,
  });

  @override
  Widget build(BuildContext context) {
    _loadContentForTab(context);
    return const SizedBox.shrink();
  }

  void _loadContentForTab(BuildContext context) {
    switch (tabIndex) {
      case 0: // Reels
        context.read<DealerProfileCubit>().loadReels(dealerId);
        break;
      case 1: // Cars
        context.read<DealerProfileCubit>().loadCars(dealerId);
        break;
      case 2: // Services
        context.read<DealerProfileCubit>().loadServices(dealerId);
        break;
    }
  }
}
