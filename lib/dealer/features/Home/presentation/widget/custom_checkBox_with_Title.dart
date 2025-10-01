import 'package:flutter/material.dart';

class CustomCheckBoxWithTitleWidget extends StatelessWidget {
  const CustomCheckBoxWithTitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),

          child: Checkbox(
            value: true,
            // splashRadius: 0,
            activeColor: Color(0xff349A51),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(4),
            ),
            onChanged: (value) {},
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff374151),
          ),
        ),
      ],
    );
  }
}
