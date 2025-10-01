import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/page/add_reels_page.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/Radio_Attack_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class attachProductOrService extends StatelessWidget {
  const attachProductOrService({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 2),
            color: Color.fromARGB(15, 0, 0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attach to Product or Service',
              style: AppTextStyle.poppins416blueBlack,
            ),
            SizedBox(height: 14.h),
            RadioAttackWidget(),
          ],
        ),
      ),
    );
  }
}
