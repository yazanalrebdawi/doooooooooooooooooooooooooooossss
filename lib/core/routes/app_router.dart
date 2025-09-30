import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/core/widgets/base/splash_screen_page.dart';
import 'package:dooss_business_app/core/services/locator_service.dart' as di;

import '../../features/auth/presentation/pages/on_boarding_screen.dart';
import '../../features/auth/presentation/pages/app_type_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/forget_password_screen.dart';
import '../../features/auth/presentation/pages/verify_otp_page.dart';
import '../../features/auth/presentation/pages/create_new_password_screen.dart';

import '../../features/cars/presentation/pages/add_car_flow.dart';
import '../../features/cars/presentation/pages/add_car_step1.dart';
import '../../features/cars/presentation/pages/add_car_step2.dart';
import '../../features/cars/presentation/pages/add_car_step3.dart';
import '../../features/cars/presentation/pages/add_car_step4.dart';
import '../../features/cars/presentation/pages/cars_screen.dart';

import '../../features/home/presentaion/pages/home_screen.dart';
import '../../features/home/presentaion/pages/all_cars_screen.dart';
import '../../features/home/presentaion/pages/all_products_screen.dart';
import '../../features/home/presentaion/pages/product_details_screen.dart';
import '../../features/home/presentaion/pages/car_details_screen.dart';
import '../../features/home/presentaion/pages/nearby_services_screen.dart';
import '../../features/home/presentaion/pages/service_map_screen.dart';
import '../../features/home/presentaion/pages/service_details_screen.dart';
import '../../features/home/presentaion/pages/reels_screen.dart';
import '../../features/home/presentaion/pages/full_screen_reels_viewer.dart';

import '../../features/chat/presentation/pages/chats_list_screen.dart';
import '../../features/chat/presentation/pages/chat_conversation_screen.dart';
import '../../features/chat/presentation/pages/create_chat_screen.dart';
import '../../features/chat/presentation/pages/chat_test_screen.dart';
import '../../features/chat/presentation/manager/chat_cubit.dart';
import '../../features/chat/data/models/chat_model.dart';

import '../../features/home/presentaion/manager/service_cubit.dart';
import '../../features/home/data/models/service_model.dart';
import '../../features/home/presentaion/manager/reel_cubit.dart';

import '../../features/profile_dealer/presentation/pages/dealer_profile_screen.dart';
import '../../features/profile_dealer/presentation/manager/dealer_profile_cubit.dart';

import '../../features/my_profile/presentation/manager/my_profile_cubit.dart';
import '../../features/my_profile/presentation/pages/change_language_screen.dart';
import '../../features/my_profile/presentation/pages/change_password_screen.dart';
import '../../features/my_profile/presentation/pages/edit_profile_screen.dart';
import '../../features/my_profile/presentation/pages/otp_verification_screen.dart';
import '../../features/my_profile/presentation/pages/profile_screen.dart';
import '../../features/my_profile/presentation/pages/saved_items_screen.dart';
import '../../features/my_profile/presentation/pages/settings_notifications_screen.dart';
import '../../features/my_profile/presentation/pages/theme_settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splashScreen,
    routes: routes,
  );

  static GoRouter createRouterWithObserver(NavigatorObserver observer) {
    return GoRouter(
      initialLocation: RouteNames.splashScreen,
      observers: [observer],
      routes: routes,
    );
  }

  static final List<RouteBase> routes = [
    // Splash & OnBoarding
    GoRoute(
      path: RouteNames.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onBoardingScreen,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: RouteNames.selectAppTypeScreen,
      builder: (context, state) => AppTypeScreen(),
    ),

    // Auth
    GoRoute(
      path: RouteNames.loginScreen,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.rigesterScreen,
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.forgetPasswordPage,
      builder: (context, state) => ForgetPasswordPage(),
    ),
    GoRoute(
      path: RouteNames.verifyForgetPasswordPage,
      builder: (context, state) {
        String phoneNumber = state.extra as String? ?? '';
        return VerifyOtpPage(phoneNumber: phoneNumber, isResetPassword: true);
      },
    ),
    GoRoute(
      path: RouteNames.verifyRegisterOtpPage,
      builder: (context, state) {
        String phoneNumber = state.extra as String? ?? '';
        return VerifyOtpPage(phoneNumber: phoneNumber, isResetPassword: false);
      },
    ),
    GoRoute(
      path: RouteNames.createNewPasswordPage,
      builder: (context, state) {
        String phoneNumber = state.extra as String? ?? '';
        return CreateNewPasswordPage(phoneNumber: phoneNumber);
      },
    ),

    // Chats
    GoRoute(
      path: RouteNames.chats,
      builder: (context, state) => const ChatsListScreen(),
    ),
    GoRoute(
      path: RouteNames.chatDetails,
      builder: (context, state) {
        final chat = state.extra as ChatModel;
        return ChatConversationScreen(
          chatId: chat.id,
          participantName: chat.dealer,
        );
      },
    ),
    GoRoute(
      path: RouteNames.chatsListScreen,
      builder: (context, state) => const ChatsListScreen(),
    ),
    GoRoute(
      path: '${RouteNames.chatConversationScreen}/:id',
      builder: (context, state) {
        final chatId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        final productId = state.extra as int?;
        return BlocProvider(
          create: (_) => di.appLocator<ChatCubit>(),
          child: ChatConversationScreen(
            chatId: chatId,
            participantName: 'Chat $chatId',
            productId: productId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/create-chat',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        return BlocProvider(
          create: (_) => di.appLocator<ChatCubit>(),
          child: CreateChatScreen(
            dealerId: args['dealerId'] ?? 0,
            dealerName: args['dealerName'] ?? 'Dealer',
          ),
        );
      },
    ),
    GoRoute(
      path: '/chat-test',
      builder: (context, state) => const ChatTestScreen(),
    ),

    // Cars
    GoRoute(
      path: RouteNames.carsScreen,
      builder: (context, state) => const CarsScreen(),
    ),
    GoRoute(
      path: RouteNames.allCarsScreen,
      builder: (context, state) => const AllCarsScreen(),
    ),
    GoRoute(
      path: RouteNames.allProductsScreen,
      builder: (context, state) => const AllProductsScreen(),
    ),
    GoRoute(
      path: '${RouteNames.productDetailsScreen}/:id',
      builder: (context, state) {
        final productId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return ProductDetailsScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/car-details/:id',
      name: 'carDetailsScreen',
      builder: (context, state) {
        final carId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return CarDetailsScreen(carId: carId);
      },
    ),
    GoRoute(
      path: RouteNames.addCarFlow,
      builder: (context, state) => AddCarFlow(),
    ),
    GoRoute(
      path: RouteNames.addCarStep1,
      builder: (context, state) => AddCarStep1(onNext: () {}),
    ),
    GoRoute(
      path: RouteNames.addCarStep2,
      builder: (context, state) => AddCarStep2(onNext: () {}),
    ),
    GoRoute(
      path: RouteNames.addCarStep3,
      builder: (context, state) => AddCarStep3(onNext: () {}),
    ),
    GoRoute(
      path: RouteNames.addCarStep4,
      builder: (context, state) => AddCarStep4(onSubmit: () {}),
    ),

    // Nearby Services
    GoRoute(
      path: RouteNames.nearbyServicesScreen,
      builder:
          (context, state) => BlocProvider(
            create: (context) => di.appLocator<ServiceCubit>(),
            child: const NearbyServicesScreen(),
          ),
    ),
    GoRoute(
      path: '/service-map',
      builder: (context, state) {
        final service = state.extra as ServiceModel?;
        return ServiceMapScreen(service: service ?? ServiceModel.placeholder());
      },
    ),
    GoRoute(
      path: '/service-details',
      builder: (context, state) {
        final service = state.extra as ServiceModel?;
        return ServiceDetailsScreen(
          service: service ?? ServiceModel.placeholder(),
        );
      },
    ),

    // Reels
    GoRoute(
      path: RouteNames.reelsScreen,
      builder: (context, state) => const FullScreenReelsViewer(),
    ),
    GoRoute(
      path: RouteNames.reelsWithId,
      builder: (context, state) {
        final reelId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return BlocProvider(
          create: (context) => di.appLocator<ReelCubit>(),
          child: ReelsScreen(initialReelId: reelId),
        );
      },
    ),

    // Dealer Profile
    GoRoute(
      path: RouteNames.dealerProfileWithId,
      builder: (context, state) {
        final dealerId = state.pathParameters['id'] ?? '0';
        return BlocProvider(
          create: (context) => di.appLocator<DealerProfileCubit>(),
          child: DealerProfileScreen(
            dealerId: dealerId,
            dealerHandle: '@cardealer_uae',
          ),
        );
      },
    ),

    // My Profile
    GoRoute(
      path: RouteNames.changeLanguageScreen,
      builder: (context, state) => ChangeLanguageScreen(),
    ),
    GoRoute(
      path: RouteNames.changePasswordScreen,
      builder:
          (context, state) => BlocProvider.value(
            value: BlocProvider.of<MyProfileCubit>(context),
            child: ChangePasswordScreen(),
          ),
    ),
    GoRoute(
      path: RouteNames.editProfileScreen,
      builder:
          (context, state) => BlocProvider.value(
            value: BlocProvider.of<MyProfileCubit>(context),
            child: EditProfileScreen(),
          ),
    ),
    GoRoute(
      path: RouteNames.profileScreen,
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.savedItemsScreen,
      builder:
          (context, state) => BlocProvider.value(
            value: BlocProvider.of<MyProfileCubit>(context),
            child: SavedItemsScreen(),
          ),
    ),
    GoRoute(
      path: RouteNames.settingsNotificationsScreen,
      builder: (context, state) => SettingsNotificationsScreen(),
    ),
    GoRoute(
      path: RouteNames.themeSettingsScreen,
      builder: (context, state) => ThemeSettingsScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: RouteNames.otpVerificationPhoneScreen,
      builder: (context, state) {
        final phone = state.extra as String;
        return BlocProvider.value(
          value: BlocProvider.of<MyProfileCubit>(context),
          child: OtpVerificationScreen(phoneNumber: phone),
        );
      },
    ),
  ];
}
