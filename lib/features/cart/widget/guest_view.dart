import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

Widget guestView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 100),
            const SizedBox(height: 20),
            const CustomText(text: "You are browsing as Guest", fontSize: 22),
            const SizedBox(height: 20),
            CustomButton(
              width: 200,
              height: 50,
              btnBackground: AppColors.primaryColor,
              title: "Login",
              titleColor: Colors.white,
              onTap: () => Get.offAll(() => LoginView()),
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }