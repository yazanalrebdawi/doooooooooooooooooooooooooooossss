import 'package:dooss_business_app/dealer/features/Home/presentation/manager/home_page_cubit.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/delete_account_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/navigotorPage.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/privacy_policy_page.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/widgets/base/splash_screen_page.dart';
import 'package:dooss_business_app/user/features/auth/presentation/pages/forget_password_screen.dart';
import 'package:dooss_business_app/user/features/auth/presentation/pages/create_new_password_screen.dart';
import 'package:dooss_business_app/user/features/auth/presentation/pages/login_screen.dart';
import 'package:dooss_business_app/user/features/auth/presentation/pages/register_screen.dart';
import 'package:dooss_business_app/user/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:dooss_business_app/user/features/cars/presentation/pages/add_car_flow.dart';
import 'package:dooss_business_app/user/features/cars/presentation/pages/add_car_step4.dart';
import 'package:dooss_business_app/user/features/chat/data/models/chat_model.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/home_screen.dart';
import 'package:dooss_business_app/user/features/cars/presentation/pages/cars_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/all_cars_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/all_products_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/product_details_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/car_details_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/change_language_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/change_password_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/delete_account_user_page.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/edit_profile_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/otp_verification_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/profile_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/saved_items_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/settings_notifications_screen.dart';
import 'package:dooss_business_app/user/features/profile_dealer/presentation/pages/dealer_profile_screen.dart';
import 'package:dooss_business_app/user/features/profile_dealer/presentation/manager/dealer_profile_cubit.dart';
import 'package:dooss_business_app/user/features/chat/presentation/pages/chats_list_screen.dart';
import 'package:dooss_business_app/user/features/chat/presentation/pages/chat_conversation_screen.dart';
import 'package:dooss_business_app/user/features/cars/presentation/pages/add_car_step1.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/nearby_services_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/service_map_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/pages/service_details_screen.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/service_cubit.dart';
import 'package:dooss_business_app/user/features/home/data/models/service_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/pages/app_type_screen.dart';
import '../../features/auth/presentation/pages/on_boarding_screen.dart';
import '../../features/cars/presentation/pages/add_car_step2.dart';
import '../../features/cars/presentation/pages/add_car_step3.dart';
import '../../features/chat/presentation/manager/chat_cubit.dart';
import '../services/locator_service.dart' as di;
import '../../features/chat/presentation/pages/create_chat_screen.dart';
import '../../features/chat/presentation/pages/chat_test_screen.dart';
import '../../features/home/presentaion/pages/reels_screen.dart';
import '../../features/home/presentaion/pages/full_screen_reels_viewer.dart';
import '../../features/home/presentaion/manager/reel_cubit.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splashScreen,
    // initialLocation: RouteNames.navigatorPage,
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
    GoRoute(
      path: RouteNames.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: RouteNames.onBoardingScreen,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: RouteNames.selectAppTypeScreen,
      builder: (context, state) => AppTypeScreen(),
    ),
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
        return VerifyOtpPage(
          phoneNumber: phoneNumber,
          isResetPassword: true,
        );
      },
    ),
    GoRoute(
      path: RouteNames.verifyRegisterOtpPage,
      builder: (context, state) {
        String phoneNumber = state.extra as String? ?? '';
        return VerifyOtpPage(
          phoneNumber: phoneNumber,
          isResetPassword: false,
        );
      },
    ),
    GoRoute(
      path: RouteNames.createNewPasswordPage,
      builder: (context, state) {
        String phoneNumber = state.extra as String? ?? '';
        return CreateNewPasswordPage(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: RouteNames.chats,
      builder: (context, state) => const ChatsListScreen(),
    ),
    GoRoute(
      path: RouteNames.chatDetails,
      builder: (context, state) {
        final chat = state.extra as ChatModel;
        return ChatConversationScreen(
          dealerName: chat.dealer.toString(),
          chatId: chat.id,
          participantName: chat.dealer,
        );
      },
    ),
    GoRoute(
      path: RouteNames.navigatorPage,
      builder: (context, state) => const NavigatorPage(),
    ),

    GoRoute(
      path: RouteNames.deleteAccountDealer,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        final blocProvider = args["blocProvide"] as HomePageCubit;
        return BlocProvider.value(
          value: blocProvider,
          child: DeleteAccountDealerPage(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.deleteAccountUser,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        final blocProvider = args["blocProvide"] as MyProfileCubit;
        return BlocProvider.value(
          value: blocProvider,
          child: DeleteAccountUserPage(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.homeScreen,
      builder: (context, state) => HomeScreen(),
    ),
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

    // GoRoute(
    //   path: '/car-details/:id',
    //   builder: (context, state) {
    //     final carId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
    //     return CarDetailsScreen(carId: carId);
    //   },
    // ),
    GoRoute(
      path: '/dealer-profile/:id',
      builder: (context, state) {
        final dealerId = state.pathParameters['id']!;
        final dealerHandle = state.uri.queryParameters['handle'] ?? '@dealer';
        return BlocProvider(
          create: (context) => di.appLocator<DealerProfileCubit>(),
          child: DealerProfileScreen(
            dealerId: dealerId,
            dealerHandle: dealerHandle,
          ),
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

        // Handle both old format (int/String) and new format (Map)
        int? productId;
        String dealerName = '';

        if (state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          productId = extra['productId'] as int?;
          dealerName = extra['dealerName'] as String? ?? '';
        } else if (state.extra is int) {
          productId = state.extra as int;
        } else if (state.extra is String) {
          productId = int.tryParse(state.extra as String);
        }

        return BlocProvider(
          create: (_) => di.appLocator<ChatCubit>(),
          child: ChatConversationScreen(
            chatId: chatId,
            participantName:
                dealerName.isNotEmpty ? dealerName : 'Chat $chatId',
            productId: productId,
            dealerName: dealerName.isNotEmpty ? dealerName : '',
          ),
        );
      },
    ),

    GoRoute(
      path: '/create-chat',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;

        final dealerId = args?['dealerId'] is String
            ? int.tryParse(args?['dealerId'])
            : args?['dealerId'] as int? ?? 0;

        final dealerName = args?['dealerName'] as String? ?? 'Dealer';

        final productId = args?['productId'] is String
            ? int.tryParse(args?['productId'])
            : args?['productId'] as int?;

        return BlocProvider(
          create: (_) => di.appLocator<ChatCubit>(),
          child: CreateChatScreen(
            dealerId: dealerId ?? 0,
            dealerName: dealerName,
            productId: productId,
          ),
        );
      },
    ),

    GoRoute(
      path: '/chat-test',
      builder: (context, state) => const ChatTestScreen(),
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
    GoRoute(
      path: RouteNames.nearbyServicesScreen,
      builder: (context, state) => BlocProvider(
        create: (context) => di.appLocator<ServiceCubit>(),
        child: const NearbyServicesScreen(),
      ),
    ),
    GoRoute(
      path: '/service-map',
      builder: (context, state) {
        // Get service from extra parameter (passed from NearbyServicesScreen)
        final service = state.extra as ServiceModel?;
        if (service != null) {
          return ServiceMapScreen(service: service);
        }
        // Fallback: create a placeholder service
        return ServiceMapScreen(
          service: ServiceModel(
            id: 1,
            name: 'Service',
            type: 'mechanic',
            city: 'Dubai',
            address: 'Dubai, UAE',
            image: '',
            phonePrimary: '+971501234567',
            phoneSecondary: '',
            open24h: false,
            openFrom: '08:00',
            openTo: '18:00',
            openNow: true,
            openingText: 'Open until 6:00 PM',
            lat: 25.2048,
            lon: 55.2708,
            callUrl: 'tel:+971501234567',
            mapsUrl: 'https://maps.google.com/?q=25.2048,55.2708',
            osmMapsUrl:
                'https://www.openstreetmap.org/?mlat=25.2048&mlon=55.2708',
            geoUrl: 'geo:25.2048,55.2708',
            staticMapUrl:
                'https://maps.googleapis.com/maps/api/staticmap?center=25.2048,55.2708&zoom=15&size=400x300&key=YOUR_API_KEY',
            hasPhone: true,
            services: ['Service 1', 'Service 2'],
          ),
        );
      },
    ),
    GoRoute(
      path: '/service-details',
      builder: (context, state) {
        // Get service from extra parameter
        final service = state.extra as ServiceModel?;
        print('🔍 AppRouter: Service Details route accessed');
        print(
          '🔍 AppRouter: Service extra parameter: ${service?.name ?? 'null'}',
        );
        if (service != null) {
          print(
            '✅ AppRouter: Creating ServiceDetailsScreen with service: ${service.name}',
          );
          return ServiceDetailsScreen(service: service);
        }
        // Fallback: create a placeholder service
        return ServiceDetailsScreen(
          service: ServiceModel(
            id: 1,
            name: 'Al Marwan Auto Workshop',
            type: 'mechanic',
            city: 'Dubai',
            address: 'Sheikh Zayed Road, Dubai, United Arab Emirates',
            image: '',
            phonePrimary: '+971 4 654 7412',
            phoneSecondary: '',
            open24h: false,
            openFrom: '08:00',
            openTo: '18:00',
            openNow: true,
            openingText: 'Open until 6:00 PM',
            lat: 25.2048,
            lon: 55.2708,
            callUrl: 'tel:+97146547412',
            mapsUrl: 'https://maps.google.com/?q=25.2048,55.2708',
            osmMapsUrl:
                'https://www.openstreetmap.org/?mlat=25.2048&mlon=55.2708',
            geoUrl: 'geo:25.2048,55.2708',
            staticMapUrl:
                'https://maps.googleapis.com/maps/api/staticmap?center=25.2048,55.2708&zoom=15&size=400x300&key=YOUR_API_KEY',
            hasPhone: true,
            services: [
              'Engine Check',
              'Oil Change',
              'Brake Inspection',
              'AC Service',
            ],
          ),
        );
      },
    ),

    // Reels Routes
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

    // Dealer Profile Routes
    GoRoute(
      path: RouteNames.dealerProfileWithId,
      builder: (context, state) {
        final dealerId = state.pathParameters['id'] ?? '0';
        return BlocProvider(
          create: (context) => di.appLocator<DealerProfileCubit>(),
          child: DealerProfileScreen(
            dealerId: dealerId,
            dealerHandle: '@cardealer_uae', // Default handle
          ),
        );
      },
    ),

    //?------------------------------------------------------------------
    //* My Profile
    GoRoute(
      path: RouteNames.changeLanguageScreen,
      builder: (context, state) => ChangeLanguageScreen(),
    ),

    GoRoute(
      path: RouteNames.changePasswordScreen,
      builder: (context, state) => BlocProvider.value(
        value: BlocProvider.of<MyProfileCubit>(context),
        child: ChangePasswordScreen(),
      ),
    ),

    GoRoute(
      path: RouteNames.editProfileScreen,
      builder: (context, state) => BlocProvider.value(
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
      builder: (context, state) => BlocProvider.value(
        value: BlocProvider.of<MyProfileCubit>(context),
        child: SavedItemsScreen(),
      ),
    ),

    GoRoute(
      path: RouteNames.settingsNotificationsScreen,
      builder: (context, state) => SettingsNotificationsScreen(),
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
