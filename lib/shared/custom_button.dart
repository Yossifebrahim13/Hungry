import 'package:flutter/material.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.btnBackground,
    required this.titleColor,
     this.title,
    this.onTap,
    this.icon,
  });
  final double width;
  final double height;
  final double fontSize;
  final Color btnBackground;
  final Color titleColor;
  final String? title;
  final Function()? onTap;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: btnBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: icon ?? CustomText(text: title!, color: titleColor, fontSize: fontSize),
      ),
    );
  }
}
