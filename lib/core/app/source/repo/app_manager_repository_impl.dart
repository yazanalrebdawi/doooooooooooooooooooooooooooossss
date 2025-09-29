import 'package:dooss_business_app/core/app/source/local/app_manager_local_data_source.dart';
import 'package:dooss_business_app/core/app/source/remote/app_magaer_remote_data_source.dart';
import 'package:dooss_business_app/core/app/source/repo/app_manager_repository.dart';
import 'package:dooss_business_app/core/services/network/network_info_service.dart';

class AppManagerRepositoryImpl implements AppManagerRepository {
  final AppMagaerRemoteDataSource remote;
  final AppManagerLocalDataSource local;
  final NetworkInfoService network;

  AppManagerRepositoryImpl({
    required this.remote,
    required this.local,
    required this.network,
  });
  //?--------------------------------------------------------------------
  

  //?--------------------------------------------------------------------
}
