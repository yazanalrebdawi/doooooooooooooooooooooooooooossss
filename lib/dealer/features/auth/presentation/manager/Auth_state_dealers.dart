// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';

class AuthStateDealers {
  final AuthDataResponse? dataUser;
  final bool isLoading;
  final String? errorMessage;

  AuthStateDealers({
    this.dataUser,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthStateDealers copyWith({
    AuthDataResponse? dataUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthStateDealers(
      dataUser: dataUser ?? this.dataUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
