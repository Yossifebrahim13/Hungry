import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/product/widget/spicy_slider.dart';
import 'package:hungry/features/product/widget/toppings_card.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  double spicy = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(ImagePath.productTest, height: 250),
                  Spacer(),
                  SpicySlider(
                    spicy: spicy,
                    onChanged: (value) => setState(() {
                      spicy = value;
                    }),
                  ),
                ],
              ),
              Gap(50),
              CustomText(
                text: "Toppings",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              Gap(15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ToppingsCard(
                        imagePath: ImagePath.toppingsTest,
                        topping: "Tomato",
                      ),
                    );
                  }),
                ),
              ),
              Gap(20),
              CustomText(
                text: "Side Options",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              Gap(15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ToppingsCard(
                        imagePath: ImagePath.toppingsTest,
                        topping: "Tomato",
                      ),
                    );
                  }),
                ),
              ),

              Gap(30),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Total",
                    color: AppColors.primaryColor,
                    fontSize: 20,
                  ),
                  CustomText(text: "\$18.3", fontSize: 25),
                ],
              ),
              Spacer(),
              CustomButton(
                width: 200,
                height: 70,
                fontSize: 20,
                btnBackground: AppColors.primaryColor,
                titleColor: Colors.white,
                title: "Add To Cart",
                onTap: () => Get.snackbar(
                  "Item added successfully",
                  "You can check your cart.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor:  const Color(0xff1a4f43),
                  duration: Duration(seconds: 1),
                  colorText: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
