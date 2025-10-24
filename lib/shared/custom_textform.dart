import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class CustomTextform extends StatefulWidget {
  const CustomTextform({
    super.key,
    required this.isPassword,
    required this.hintText,
    required this.controller,
  });

  final bool isPassword;
  final String hintText;
  final TextEditingController controller;

  @override
  State<CustomTextform> createState() => _CustomTextformState();
}

class _CustomTextformState extends State<CustomTextform> {
  IconData icon = CupertinoIcons.eye_slash;
  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
      icon = obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye;
    });
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? obscureText : false,
        cursorColor: AppColors.primaryColor,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white70, fontSize: fontSize),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: togglePasswordVisibility,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: size.width * 0.06,
                  ),
                )
              : null,

          enabledBorder: _border(Colors.white),
          focusedBorder: _border(Colors.white),
          errorBorder: _border(Colors.redAccent),
          focusedErrorBorder: _border(Colors.redAccent),

          errorStyle: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.w500,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${widget.hintText} is required';
          }
          if (widget.hintText == "Email Address" && !value.contains('@')) {
            return 'Please enter a valid email address';
          }
          if (widget.hintText == "Password" && value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
      ),
    );
  }
}
