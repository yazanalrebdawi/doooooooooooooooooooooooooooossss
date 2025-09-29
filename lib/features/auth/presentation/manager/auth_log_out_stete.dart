// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dooss_business_app/core/utils/response_status_enum.dart';

class AuthLogOutStete {
  final ResponseStatusEnum? logOutStatus;
  final String? errorLogOut;

  AuthLogOutStete({
    this.logOutStatus = ResponseStatusEnum.initial,
    this.errorLogOut,
  });

  AuthLogOutStete copyWith({
    ResponseStatusEnum? logOutStatus,
    String? errorLogOut,
  }) {
    return AuthLogOutStete(
      logOutStatus: logOutStatus ?? this.logOutStatus,
      errorLogOut: errorLogOut,
    );
  }
}
