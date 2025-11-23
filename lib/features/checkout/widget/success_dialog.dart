import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const Gap(15),
                CustomText(
                  text: "Success !",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const Gap(15),
                const Text(
                  "Your payment was successful.\nA receipt for this purchase has been sent to your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const Gap(25),
                CustomButton(
                  width: double.infinity,
                  height: 50,
                  fontSize: 20,
                  btnBackground: AppColors.primaryColor,
                  titleColor: Colors.white,
                  title: 'Go Back',
                  onTap: () => Get.offAll(() => Root()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
