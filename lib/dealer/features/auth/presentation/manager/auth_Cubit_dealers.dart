import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/Auth_state_dealers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubitDealers extends Cubit<AuthStateDealers> {
  AuthCubitDealers(this.data) : super(AuthStateDealers());
  final DealersAuthRemouteDataSource data;

  void SignIn({required String name ,required String password , required code}) async {
    print('SignIn() called in Cubit'); // add this line

    var result = await data.SignIn(code: code , name: name , password: password);
    result.fold(
      (Error) {
        print(Error);
      },
      (data) {
        print(data.access);
        emit(state.copyWith(dataUser: data));
      },
    );
  }
}
