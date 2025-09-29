// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/constants/colors.dart';
// import '../../../../core/constants/text_styles.dart';
// import '../../../../core/routes/route_names.dart';
// import '../../../../core/services/locator_service.dart';
// import '../../../../core/localization/app_localizations.dart';
// import '../../../auth/presentation/manager/auth_cubit.dart';
// import '../../../auth/presentation/manager/auth_state.dart';
// import '../../../auth/presentation/widgets/custom_app_snack_bar.dart';

// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => appLocator<AuthCubit>(),
//       child: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state.checkAuthState == CheckAuthState.logoutSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               customAppSnackBar(
//                 AppLocalizations.of(context)?.translate('logoutSuccess') ??
//                     "Logged out successfully!",
//                 context,
//               ),
//             );

//             // تأخير قصير ثم الانتقال إلى شاشة تسجيل الدخول
//             Future.delayed(const Duration(milliseconds: 500), () {
//               context.go(RouteNames.loginScreen);
//             });
//           }
//           if (state.checkAuthState == CheckAuthState.error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               customAppSnackBar(
//                 state.error ??
//                     AppLocalizations.of(
//                       context,
//                     )?.translate('operationFailed') ??
//                     "Operation failed",
//                 context,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: AppColors.background,
//             body: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.all(24.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Text(
//                       AppLocalizations.of(context)?.translate('account') ??
//                           'Account',
//                       style: AppTextStyles.s22w700,
//                     ),
//                     SizedBox(height: 32.h),

//                     // Profile Section
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(20.w),
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         borderRadius: BorderRadius.circular(12.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.cardShadow,
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           // Profile Avatar
//                           Container(
//                             width: 80.w,
//                             height: 80.w,
//                             decoration: BoxDecoration(
//                               color: AppColors.primary.withOpacity(0.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.person,
//                               size: 40.sp,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                           SizedBox(height: 16.h),

//                           // User Name
//                           Text('User Name', style: AppTextStyles.s16w600),
//                           SizedBox(height: 8.h),

//                           // User Email/Phone
//                           Text(
//                             'user@example.com',
//                             style: AppTextStyles.s14w400.copyWith(
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 24.h),

//                     // Account Options
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         borderRadius: BorderRadius.circular(12.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.cardShadow,
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           // Profile Settings
//                           _buildOptionItem(
//                             context,
//                             icon: Icons.person_outline,
//                             title:
//                                 AppLocalizations.of(
//                                   context,
//                                 )?.translate('profileSettings') ??
//                                 'Profile Settings',
//                             onTap: () {},
//                           ),

//                           // Change Password
//                           _buildOptionItem(
//                             context,
//                             icon: Icons.lock_outline,
//                             title:
//                                 AppLocalizations.of(
//                                   context,
//                                 )?.translate('changePassword') ??
//                                 'Change Password',
//                             onTap: () {},
//                           ),

//                           // Notifications
//                           _buildOptionItem(
//                             context,
//                             icon: Icons.notifications_outlined,
//                             title:
//                                 AppLocalizations.of(
//                                   context,
//                                 )?.translate('notifications') ??
//                                 'Notifications',
//                             onTap: () {},
//                           ),

//                           // Language
//                           _buildOptionItem(
//                             context,
//                             icon: Icons.language_outlined,
//                             title:
//                                 AppLocalizations.of(
//                                   context,
//                                 )?.translate('language') ??
//                                 'Language',
//                             onTap: () {},
//                           ),
//                         ],
//                       ),
//                     ),

//                     const Spacer(),

//                     // Logout Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed:
//                             state.isLoading
//                                 ? null
//                                 : () {
//                                   _showLogoutDialog(context);
//                                 },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: AppColors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16.h),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         child:
//                             state.isLoading
//                                 ? SizedBox(
//                                   width: 20.w,
//                                   height: 20.w,
//                                   child: CircularProgressIndicator(
//                                     color: AppColors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                                 : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.logout, size: 20.sp),
//                                     SizedBox(width: 8.w),
//                                     Text(
//                                       AppLocalizations.of(
//                                             context,
//                                           )?.translate('logout') ??
//                                           'Logout',
//                                       style: AppTextStyles.s16w600.copyWith(
//                                         color: AppColors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOptionItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.primary, size: 24.sp),
//             SizedBox(width: 16.w),
//             Expanded(child: Text(title, style: AppTextStyles.s16w400)),
//             Icon(Icons.arrow_forward_ios, color: AppColors.gray, size: 16.sp),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     // احتفظ بالـ cubit قبل فتح الـ dialog
//     final authCubit = context.read<AuthCubit>();

//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           title: Text(
//             AppLocalizations.of(context)?.translate('logout') ?? 'Logout',
//             style: AppTextStyles.s16w600,
//           ),
//           content: Text(
//             AppLocalizations.of(context)?.translate('logoutConfirmation') ??
//                 'Are you sure you want to logout?',
//             style: AppTextStyles.s16w400,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: Text(
//                 AppLocalizations.of(context)?.translate('cancel') ?? 'Cancel',
//                 style: AppTextStyles.s16w400.copyWith(color: AppColors.gray),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 // استخدم الـ cubit المحفوظ بدلاً من context.read
//                 authCubit.logout();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: AppColors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//               child: Text(
//                 AppLocalizations.of(context)?.translate('logout') ?? 'Logout',
//                 style: AppTextStyles.s16w600.copyWith(color: AppColors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
// // import 'package:dooss_business_app/core/localization/app_localizations.dart';
// // import 'package:dooss_business_app/features/auth/presentation/manager/auth_cubit.dart';
// // import 'package:dooss_business_app/features/auth/presentation/manager/auth_state.dart';
// // import 'package:dooss_business_app/features/auth/presentation/widgets/custom_app_snack_bar.dart';
// // import 'package:dooss_business_app/features/my_profile/presentation/widgets/settings_row_widget.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:dooss_business_app/core/constants/colors.dart';
// // import 'package:dooss_business_app/core/constants/text_styles.dart';

// // class LogOutSettingsWidget extends StatelessWidget {
// //   const LogOutSettingsWidget({super.key});

// //   void _showLogoutDialog(BuildContext context) {
// //     final authCubit = context.read<AuthCubit>();
// //     final appManagerCubit = context.read<AppManagerCubit>();

// //     showDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       builder: (dialogContext) {
// //         return BlocConsumer<AuthCubit, AuthState>(
// //           listener: (context, state) {
// //             if (state.checkAuthState == CheckAuthState.logoutSuccess) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 customAppSnackBar(
// //                   AppLocalizations.of(context)?.translate('logoutSuccess') ??
// //                       "Logged out successfully!",
// //                   context,
// //                 ),
// //               );
// //               appManagerCubit.logOut();

// //               Future.delayed(const Duration(milliseconds: 500), () {
// //                 Navigator.of(dialogContext).pop(); // اغلاق الدايالوغ
// //                 // هنا ممكن تعمل navigation للشاشة المناسبة
// //               });
// //             }

// //             if (state.checkAuthState == CheckAuthState.error) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 customAppSnackBar(
// //                   state.error ??
// //                       AppLocalizations.of(
// //                         context,
// //                       )?.translate('operationFailed') ??
// //                       "Operation failed",
// //                   context,
// //                 ),
// //               );
// //             }
// //           },
// //           builder: (context, state) {
// //             return Dialog(
// //               backgroundColor: AppColors.background,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(16.r),
// //               ),
// //               elevation: 5,
// //               child: Padding(
// //                 padding: EdgeInsets.all(16.w),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Text(
// //                       AppLocalizations.of(context)?.translate('Log Out') ??
// //                           'Log Out',
// //                       style: AppTextStyles.blackS18W500.copyWith(
// //                         fontFamily: AppTextStyles.fontPoppins,
// //                       ),
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     Text(
// //                       AppLocalizations.of(
// //                             context,
// //                           )?.translate('Are you sure you want to log out ?') ??
// //                           'Are you sure you want to log out ?',
// //                       textAlign: TextAlign.center,
// //                       style: AppTextStyles.s14w400.copyWith(
// //                         fontFamily: AppTextStyles.fontPoppins,
// //                         color: AppColors.textSecondary,
// //                       ),
// //                     ),
// //                     SizedBox(height: 24.h),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         Expanded(
// //                           child: ElevatedButton(
// //                             onPressed: () => Navigator.of(dialogContext).pop(),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Color(0xffE5E7EB),
// //                               foregroundColor: Colors.black,
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12.r),
// //                               ),
// //                               padding: EdgeInsets.symmetric(vertical: 12.h),
// //                             ),
// //                             child: Text(
// //                               AppLocalizations.of(
// //                                     context,
// //                                   )?.translate('Cancel') ??
// //                                   'Cancel',
// //                               style: AppTextStyles.s14w500,
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(width: 16.w),
// //                         Expanded(
// //                           child: ElevatedButton(
// //                             onPressed:
// //                                 state.isLoading
// //                                     ? null
// //                                     : () => authCubit.logout(),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Color(0xffDC2626),
// //                               foregroundColor: Colors.white,
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12.r),
// //                               ),
// //                               padding: EdgeInsets.symmetric(vertical: 12.h),
// //                             ),
// //                             child:
// //                                 state.isLoading
// //                                     ? SizedBox(
// //                                       width: 20.w,
// //                                       height: 20.w,
// //                                       child: CircularProgressIndicator(
// //                                         color: AppColors.white,
// //                                         strokeWidth: 2,
// //                                       ),
// //                                     )
// //                                     : Text(
// //                                       AppLocalizations.of(
// //                                             context,
// //                                           )?.translate('Log Out') ??
// //                                           'Log Out',
// //                                       style: AppTextStyles.s14w500.copyWith(
// //                                         fontFamily: AppTextStyles.fontPoppins,
// //                                         color: AppColors.buttonText,
// //                                       ),
// //                                     ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SettingsRowWidget(
// //       iconBackgroundColor: Color(0xffFEE2E2),
// //       iconColor: Color(0xffDC2626),
// //       iconData: Icons.logout,
// //       isWidgetLogOut: true,
// //       text: "Log Out",
// //       trailing: Icon(
// //         Icons.arrow_forward_ios,
// //         size: 16.r,
// //         color: Color(0xff9CA3AF),
// //       ),
// //       onTap: () => _showLogoutDialog(context),
// //     );
// //   }
// // }
