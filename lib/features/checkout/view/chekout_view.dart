import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/checkout/widget/order_details_widget.dart';
import 'package:hungry/features/checkout/widget/success_dialog.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class ChekoutView extends StatefulWidget {
  const ChekoutView({super.key});

  @override
  State<ChekoutView> createState() => _ChekoutViewState();
}

class _ChekoutViewState extends State<ChekoutView> {
  bool isChecked = false;
  String selectedMethod = 'Cash';
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
              OrderDetailsWidget(
                order: '18.50',
                taxes: '0.3',
                fees: '2.30',
                total: '21.13',
                time: '15 - 30 mins',
              ),
              Gap(70),
              CustomText(
                text: "Payment methods",
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              Gap(20),
              ListTile(
                onTap: () => setState(() => selectedMethod = 'Cash'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                tileColor: Color(0xff3C2F2F),
                leading: Image.asset(ImagePath.dollarSignIcon),
                title: CustomText(
                  text: 'Cash on delivery',
                  color: Colors.white,
                ),
                trailing: Radio(
                  activeColor: Colors.white,
                  value: "Cash",
                  groupValue: selectedMethod,
                  onChanged: (value) => setState(() => selectedMethod = value!),
                ),
              ),
              Gap(10),
              ListTile(
                onTap: () => setState(() => selectedMethod = 'Visa'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                tileColor: Colors.lightBlueAccent,
                leading: Image.asset(ImagePath.visaIcon),
                title: CustomText(text: 'Debit Card', color: Colors.white),
                subtitle: CustomText(
                  text: '**** **** **** 2356',
                  color: Colors.white,
                ),
                trailing: Radio(
                  activeColor: Colors.white,
                  value: "Visa",
                  groupValue: selectedMethod,
                  onChanged: (value) => setState(() => selectedMethod = value!),
                ),
              ),
              Gap(5),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) =>
                        setState(() => isChecked = value ?? false),
                    activeColor: const Color(0xffEF2A39),
                  ),

                  CustomText(
                    text: "Save card details for future payments",
                    fontSize: 16,
                  ),
                ],
              ),
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
                    text: "Total : ",
                    color: AppColors.primaryColor,
                    fontSize: 20,
                  ),
                  CustomText(
                    text: "\$21.13",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const Spacer(),
              CustomButton(
                width: 170,
                height: 60,
                fontSize: 20,
                btnBackground: AppColors.primaryColor,
                titleColor: Colors.white,
                title: "Pay Now",
                onTap: () {
                  Get.dialog(
                    const SuccessDialog(),
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.4),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
