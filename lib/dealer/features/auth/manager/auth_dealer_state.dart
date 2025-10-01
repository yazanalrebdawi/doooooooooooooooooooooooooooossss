import 'package:dooss_business_app/user/features/auth/presentation/manager/auth_state.dart';
import 'package:dooss_business_app/user/features/profile_dealer/data/models/dealer_model.dart';

class AuthDealerState {
  final bool isLoading;
  final String? error;
  final String? success;
  final DealerModel? dealer;

  AuthDealerState({
    this.isLoading = false,
    this.error,
    this.success,
    this.dealer,
  });

  AuthDealerState copyWith({
    bool? isLoading,
    String? error,
    String? success,
    CheckAuthState? checkAuthState,
    DealerModel? dealer,
  }) {
    return AuthDealerState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
      dealer: dealer ?? this.dealer,
    );
  }
}
