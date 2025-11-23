import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class OptionItem extends StatelessWidget {
  final String name;
  final String image;

  const OptionItem({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.fastfood, size: 40, color: Colors.grey),
          ),
        ),
        const Gap(3),
        CustomText(
          text: name,
          fontSize: 12,
          color: Colors.black87,
        ),
      ],
    );
  }
}
