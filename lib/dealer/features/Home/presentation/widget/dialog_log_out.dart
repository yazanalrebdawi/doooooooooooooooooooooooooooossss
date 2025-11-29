import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return showDialogLogOut();
    },
  );
}

class showDialogLogOut extends StatelessWidget {
  const showDialogLogOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text('Confirm Logout'),
      content: Text('Are you sure you want to log out from your account?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // إغلاق الحوار
          },
          child: Text('Cancel',style:TextStyle(color: Colors.black) ,),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            // Use removeAllExceptPrivacyPolicy to preserve privacy policy acceptance
            await appLocator<SharedPreferencesService>().removeAllExceptPrivacyPolicy();
            if (context.mounted) {
              context.go(RouteNames.splashScreen);
              Navigator.of(context).pop(); // إغلاق الحوار
            }
            // أضف هنا منطق تسجيل الخروج
            print('تم تسجيل الخروج');
          },
          child: Text('Log Out',style:TextStyle(color: Colors.white) ,),
        ),
      ],
    );
  }
}
