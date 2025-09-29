import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class RegisterScreenHeaderSection extends StatelessWidget {
  const RegisterScreenHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
<<<<<<< HEAD
=======
      
>>>>>>> zoz
        Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)?.translate('Sign Up') ?? 'Sign Up',
<<<<<<< HEAD
            style: AppTextStyles.headLineBlackS30W600.withThemeColor(context),
=======
            style: AppTextStyles.headLineBlackS30W600,
>>>>>>> zoz
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
<<<<<<< HEAD
}
=======
} 
>>>>>>> zoz
