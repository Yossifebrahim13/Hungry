import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const QuantityButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(5),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
