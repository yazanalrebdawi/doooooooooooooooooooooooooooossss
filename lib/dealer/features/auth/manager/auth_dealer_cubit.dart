// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:dooss_business_app/dealer/features/auth/manager/auth_dealer_state.dart';
// import 'package:dooss_business_app/dealer/features/auth/remote/auth_dealer_remote_data_source.dart';
// import 'package:dooss_business_app/user/core/network/app_dio.dart';
// import 'package:dooss_business_app/user/core/network/failure.dart';
// import 'package:dooss_business_app/user/core/services/locator_service.dart';
// import 'package:dooss_business_app/user/core/services/token_service.dart';
// import 'package:dooss_business_app/user/features/profile_dealer/data/models/dealer_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthCubit extends Cubit<AuthDealerState> {
//   AuthCubit({required this.remote}) : super(AuthDealerState());
//   final AuthDealerRemoteDataSource remote;

// //? -------------------------------------------------------------------------

//   //! Done ✅
//   /// تسجيل الدخول
//   Future<void> signIn(
//     String name,
//     String password,
//     String code,
//   ) async {
//     log("🚀 AuthCubit - Starting sign in process");
//     emit(state.copyWith(isLoading: true));

//     final Either<Failure, DealerModel> result =
//         await remote.signInDealer(name, password, code);

//     result.fold(
//       (failure) {
//         log("❌ AuthCubit - Sign in failed: ${failure.message}");
//         emit(
//           state.copyWith(
//             isLoading: false,
//             error: failure.message,
       
//           ),
//         );
//       },
//       (authResponse) async {
     

     
//         if (authResponse.token.isNotEmpty) {
//           log("✅ AuthCubit - Token saved automatically in DealerModel ");
//           TokenService.saveToken(authResponse.token);

//           // اختبار التحقق من الـ authentication
//           final hasToken = await TokenService.hasToken();
//           log("🔍 AuthCubit - Has token: $hasToken");
//           //? -------------------------------------------------------------------

//           final cachedToken = await TokenService.getToken();

//           if (cachedToken != null && cachedToken.isNotEmpty) {
//             final isExpired = await TokenService.isTokenExpired();
//             if (!isExpired) {
//               appLocator<AppDio>().addTokenToHeader(cachedToken);
//               log("Token added to Dio header");
//             }
//           }
//           saveAuthRespnseModel(authResponse);
//           //? -------------------------------------------------------------------

//           // اختبار AuthService
//           final isAuthenticated = await AuthService.isAuthenticated();
//           log("🔍 AuthCubit - Is authenticated: $isAuthenticated");
//         } else {
//           log("⚠️ AuthCubit - Token is empty");
//           log(
//             "⚠️ AuthCubit - This might be the issue - API is not returning token",
//           );
//         }
//         if (authResponse.user != null) {
//           await secureStorage.saveAuthModel(authResponse);
//           log("💾 AuthCubit - User data saving temporarily disabled");
//         }

//         emit(
//           state.copyWith(
//             isLoading: false,
//             checkAuthState: CheckAuthState.signinSuccess,
//             success: authResponse.message,
//           ),
//         );
//       },
//     );
//   }
// }
