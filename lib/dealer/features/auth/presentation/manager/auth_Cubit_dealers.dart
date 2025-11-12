import 'dart:developer';

import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_state_dealers.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubitDealers extends Cubit<AuthStateDealers> {
  final DealersAuthRemouteDataSource data;

  AuthCubitDealers(this.data) : super(AuthStateDealers());

  Future<void> signIn({
    required String name,
    required String password,
    required String code,
  }) async {
    print('🔹 signIn() called in Cubit');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result =
        await data.SignIn(code: code, name: name, password: password);

    result.fold((error) {
      print('❌ Error: ${error.message}');
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    }, (resultData) async {
      final secureStorage = appLocator<SecureStorageService>();
      await secureStorage.saveDealerAuthData(resultData);
      await secureStorage.setIsDealer(true);
      await TokenService.saveToken(resultData.access);
      log('✅ Access Token: ${resultData.access}');
      emit(state.copyWith(
        isLoading: false,
        dataUser: resultData,
        errorMessage: null,
      ));
    });
  }
}
