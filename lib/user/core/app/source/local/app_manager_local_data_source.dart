import 'package:dooss_business_app/user/features/auth/data/models/auth_response_model.dart';

abstract class AppManagerLocalDataSource {
  Future<AuthResponceModel?> getFullUser();
  Future<void> saveFullUser(AuthResponceModel authModel);
}
