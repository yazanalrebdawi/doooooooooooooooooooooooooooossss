import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class NumberFormatterWidget extends StatelessWidget {
  final int number;

  const NumberFormatterWidget({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatNumber(number),
      style: AppTextStyles.s18w700.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      double k = number / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return number.toString();
  }
}
