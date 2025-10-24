import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customSnackBar(String mainText, String subText, Color backgroundColor) {
  Get.snackbar(
    mainText,
    subText,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor,
    duration: Duration(seconds: 1),
    colorText: Colors.white,
  );
}
