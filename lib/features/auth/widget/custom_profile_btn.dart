import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomProfileBtn extends StatefulWidget {
  const CustomProfileBtn({
    super.key,
    this.onTap,
    required this.text,
    required this.icon,
    this.backGroundColor,
    this.iconColor,
    this.textColor,
    required this.borderColor,
  });
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color? backGroundColor;
  final Color borderColor;
  final Color? iconColor;
  final Color? textColor;

  @override
  State<CustomProfileBtn> createState() => _CustomProfileBtnState();
}

class _CustomProfileBtnState extends State<CustomProfileBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: widget.backGroundColor,
          border: Border.all(width: 2, color: widget.borderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CustomText(
              text: widget.text,
              fontSize: 16,
              color: widget.textColor,
            ),
            Gap(10),
            Icon(widget.icon, color: widget.iconColor),
          ],
        ),
      ),
    );
  }
}
