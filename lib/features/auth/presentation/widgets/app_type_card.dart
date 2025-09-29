import 'package:flutter/material.dart';

class AppTypeButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final Color buttonColor;
  final TextStyle textStyle;

  const AppTypeButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonColor, required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: BorderRadius.circular(10.0),
      onTap: onTap,
      child: GestureDetector(
        child: Container(
          height: 71,
          width: double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          // padding: EdgeInsets.all(25),
          child: Center(
            child: Text(
              buttonText,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
