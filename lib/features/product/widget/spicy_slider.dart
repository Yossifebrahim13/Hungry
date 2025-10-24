import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider({super.key, required this.spicy, required this.onChanged});
  final double spicy;
  final ValueChanged<double> onChanged;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            CustomText(
          text:
              "Customize Your Burger \n to  Your Tastes. Ultimate \n Experience",
              fontSize: 16,
        ),
        Slider(
          min: 0.0,
          max: 1.0,
          activeColor: widget.spicy >= 0.5 ? Colors.red : Colors.blue,
          inactiveColor: Colors.grey.shade300,
          value: widget.spicy,
          onChanged: widget.onChanged,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomText(text: "🥶"),
            Gap(100),
            CustomText(text: "🌶"),
          ],
        ),
          ],
        )
      ],
    );
  }
}
