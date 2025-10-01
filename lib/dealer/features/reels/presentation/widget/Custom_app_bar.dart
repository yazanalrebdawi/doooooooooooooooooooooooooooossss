import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final double elevation;
  final Function() ontap;
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = Colors.blue,
    this.elevation = 8.0,
    required this.ontap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(80); // ارتفاع الـ AppBar

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              96,
              0,
              0,
              0,
            ).withOpacity(0.1), // لون الظل
            spreadRadius: 2, // مدى انتشار الظل
            blurRadius: elevation, // نعومة الظل
            offset: Offset(0, 1), // اتجاه الظل
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: const Color.fromARGB(255, 40, 39, 39),
            ),
            onPressed: () {
              ontap();
              Navigator.pop(context); // وظيفة السهم
            },
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.poppins616blueDark),
              Text(
                subtitle,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color.fromARGB(179, 0, 0, 0),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
