import 'package:dooss_business_app/core/services/network/network_info_service.dart';
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source.dart';
import 'package:dooss_business_app/features/auth/data/source/repo/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final NetworkInfoService network;

  AuthRepositoryImpl({required this.remote, required this.network});
  //?------------------------------------------------------------------------
  
  //?------------------------------------------------------------------------
}
