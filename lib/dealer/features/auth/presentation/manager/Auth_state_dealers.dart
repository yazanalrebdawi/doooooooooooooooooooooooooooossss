// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';

class AuthStateDealers {
  final AuthDataResponse? dataUser;

  AuthStateDealers({this.dataUser});

  AuthStateDealers copyWith({AuthDataResponse? dataUser}) {
    return AuthStateDealers(dataUser: dataUser ?? this.dataUser);
  }
}
