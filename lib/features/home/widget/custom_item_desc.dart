import 'package:flutter/material.dart';

class CustomItemDesc extends StatelessWidget {
  const CustomItemDesc({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
  });
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
