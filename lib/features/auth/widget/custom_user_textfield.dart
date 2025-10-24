import 'package:flutter/material.dart';

class CustomUserTextfield extends StatelessWidget {
  const CustomUserTextfield({
    super.key,
    required this.lable,
    required this.controller,
    this.textInputType,
    this.isEdited,
  });
  final TextEditingController controller;
  final String lable;
  final TextInputType? textInputType;
  final bool? isEdited;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      readOnly: isEdited ?? true,
      controller: controller,
      cursorColor: Colors.white,

      style: TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        labelText: lable,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
