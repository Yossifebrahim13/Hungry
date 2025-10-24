import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
    required this.time,
  });
  final String order, taxes, fees, total, time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: "Order Summary",
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        Gap(15),
        chekoutWidget("Order", order, false, false),
        Gap(10),
        chekoutWidget("Taxes", taxes, false, false),
        Gap(10),
        chekoutWidget("Delivery fees", fees, false, false),
        Gap(10),
        Divider(endIndent: 30, indent: 30, color: Colors.grey.shade400),
        Gap(10),
        chekoutWidget("Total : ", total, true, false),
        Gap(10),
        chekoutWidget("Estimated delivery time:", time, true, true),
      ],
    );
  }
}

Widget chekoutWidget(title, value, isBold, isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        fontSize: isSmall ? 16 : 18,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        color: isBold ? Colors.black : Colors.grey.shade800,
      ),
      CustomText(
        text: isSmall ? value : "\$$value",
        fontSize: isSmall ? 16 : 18,
        color: isBold ? Colors.black : Colors.grey.shade800,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
      ),
    ],
  );
}
