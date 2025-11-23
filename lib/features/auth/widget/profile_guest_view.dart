import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/view/signup_view.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

Widget profileGuestView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_4_sharp, size: 100),
            const SizedBox(height: 20),
            const CustomText(text: "You are browsing as Guest", fontSize: 22),
            const SizedBox(height: 20),
            CustomButton(
              width: 200,
              height: 50,
              btnBackground: AppColors.primaryColor,
              title: "Sign Up",
              titleColor: Colors.white,
              onTap: () => Get.offAll(() => SignupView()),
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }