import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/shared/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(30),
            SvgPicture.asset(
              ImagePath.logo,
              color: AppColors.primaryColor,
              height: 35,
            ),
            Gap(5),
            CustomText(
              text: "Hello , ${user?.name}",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ],
        ),
        Spacer(),
        Container(
          height: 90,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
            border: Border.all(width: 3, color: Colors.white),
          ),
          clipBehavior: Clip.antiAlias,
          child: (user?.image != null && user!.image!.isNotEmpty)
              ? Image.network(
                  user!.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, builder) => Icon(Icons.person),
                )
              : Icon(Icons.person),
        ),
      ],
    );
  }
}
