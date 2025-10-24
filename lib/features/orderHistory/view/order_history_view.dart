import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: ListView.builder(
          padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.12),
          physics: const BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: height * 0.01),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.015,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product image
                        Container(
                          width: width * 0.25,
                          height: width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(ImagePath.homeTest),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Gap(width * 0.04),
                        // Product info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Cheese Burger",
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                              Gap(height * 0.008),
                              CustomText(
                                text: "Quantity: 3",
                                color: Colors.grey.shade800,
                                fontSize: width * 0.04,
                              ),
                              Gap(height * 0.004),
                              CustomText(
                                text: "Price: 30\$",
                                color: Colors.grey.shade800,
                                fontSize: width * 0.04,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(height * 0.015),
                    CustomButton(
                      width: double.infinity,
                      height: height * 0.06,
                      fontSize: width * 0.045,
                      btnBackground: AppColors.primaryColor,
                      titleColor: Colors.white,
                      title: "Order Again",
                      onTap: () {
                        Get.showSnackbar(
                          GetSnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppColors.primaryColor.withOpacity(
                              0.8,
                            ),
                            borderRadius: 8,
                            margin: EdgeInsets.all(width * 0.04),
                            message: "Thanks for reordering!",
                            snackPosition: SnackPosition.BOTTOM,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
