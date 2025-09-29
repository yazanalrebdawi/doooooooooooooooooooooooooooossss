import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/locator_service.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/manager/auth_cubit.dart';
import '../../../auth/presentation/manager/auth_state.dart';
import '../../../auth/presentation/widgets/custom_app_snack_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.checkAuthState == CheckAuthState.logoutSuccess) {
            sl<ToastNotification>().showSuccessMessage(
              context,
              AppLocalizations.of(context)?.translate('logoutSuccess') ??
                  "Logged out successfully!",
            );
            // تأخير قصير ثم الانتقال إلى شاشة تسجيل الدخول
            Future.delayed(const Duration(milliseconds: 500), () {
              context.go(RouteNames.loginScreen);
            });
          }
          if (state.checkAuthState == CheckAuthState.error) {
            sl<ToastNotification>().showErrorMessage(
              context,
              state.error ??
                  AppLocalizations.of(context)?.translate('operationFailed') ??
                  "Operation failed",
            );
          }
        },
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      AppLocalizations.of(context)?.translate('account') ??
                          'Account',
                      style: AppTextStyles.s22w700.withThemeColor(context),
                    ),
                    SizedBox(height: 32.h),

                    // Profile Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF2A2A2A) : AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Avatar
                          Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // User Name
                          Text(
                            'User Name',
                            style:
                                AppTextStyles.s16w600.withThemeColor(context),
                          ),
                          SizedBox(height: 8.h),

                          // User Email/Phone
                          Text(
                            'user@example.com',
                            style: AppTextStyles.s14w400.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Account Options
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ColoredBox(
                        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
                        child: Column(
                          children: [
                            // Profile Settings
                            _buildOptionItem(
                              context,
                              icon: Icons.person_outline,
                              title: AppLocalizations.of(context)
                                      ?.translate('profileSettings') ??
                                  'Profile Settings',
                              onTap: () {},
                            ),

                            // Change Password
                            _buildOptionItem(
                              context,
                              icon: Icons.lock_outline,
                              title: AppLocalizations.of(context)
                                      ?.translate('changePassword') ??
                                  'Change Password',
                              onTap: () {},
                            ),

                            // Notifications
                            _buildOptionItem(
                              context,
                              icon: Icons.notifications_outlined,
                              title: AppLocalizations.of(context)
                                      ?.translate('notifications') ??
                                  'Notifications',
                              onTap: () {},
                            ),

                            // Language
                            _buildOptionItem(
                              context,
                              icon: Icons.language_outlined,
                              title: AppLocalizations.of(context)
                                      ?.translate('language') ??
                                  'Language',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                _showLogoutDialog(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: state.isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    AppLocalizations.of(context)
                                            ?.translate('logout') ??
                                        'Logout',
                                    style: AppTextStyles.s16w600.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.s16w400.withThemeColor(context),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.white : AppColors.gray,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // احتفظ بالـ cubit قبل فتح الـ dialog
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            AppLocalizations.of(context)?.translate('logout') ?? 'Logout',
            style: AppTextStyles.s16w600.withThemeColor(context),
          ),
          content: Text(
            AppLocalizations.of(context)?.translate('logoutConfirmation') ??
                'Are you sure you want to logout?',
            style: AppTextStyles.s16w400.withThemeColor(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)?.translate('cancel') ?? 'Cancel',
                style: AppTextStyles.s16w400.copyWith().withThemeColor(context),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // استخدم الـ cubit المحفوظ بدلاً من context.read
                authCubit.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)?.translate('logout') ?? 'Logout',
                style: AppTextStyles.s16w600.copyWith().withThemeColor(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
