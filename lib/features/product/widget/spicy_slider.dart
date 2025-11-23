import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/product/widget/costum_product_desc.dart';
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
    final sliderColor = Color.lerp(Colors.blue, Colors.red, widget.spicy)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomProductDesc(
          text:
              "Customize Your Burger \n to Your Tastes. Ultimate \n Experience",
          fontSize: 12,
        ),
        const Gap(10),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: sliderColor,
            thumbColor: sliderColor,
            inactiveTrackColor: Colors.grey.shade300,
            trackHeight: 5,
          ),
          child: Slider(
            min: 0.0,
            max: 1.0,
            value: widget.spicy,
            onChanged: widget.onChanged,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CustomText(text: "🥶"),
            CustomText(text: "🌶"),
          ],
        ),
      ],
    );
  }
}
