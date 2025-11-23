import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/shared/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key, this.userName, this.userImageUrl});
  final String? userName;
  final String? userImageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(30),
            SvgPicture.asset(
              ImagePath.logo,
              color: AppColors.primaryColor,
              height: 35,
            ),
            const Gap(5),
            CustomText(
              text: "Hello, ${userName ?? 'Guest'} 👋",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ],
        ),

        const Spacer(),

        // Profile image circle
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
            border: Border.all(width: 3, color: Colors.white),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildProfileImage(),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (userImageUrl == null || userImageUrl!.isEmpty) {
      return Icon(Icons.person, size: 40, color: Colors.grey.shade600);
    }

    return Image.network(
      userImageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) {
        return Icon(Icons.person, size: 40, color: Colors.grey.shade600);
      },
    );
  }
}
