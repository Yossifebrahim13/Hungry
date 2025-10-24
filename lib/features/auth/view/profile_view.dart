import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/view/signup_view.dart';
import 'package:hungry/features/auth/widget/custom_profile_btn.dart';
import 'package:hungry/features/auth/widget/custom_user_textfield.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_snack_bar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _visaController = TextEditingController();

  bool isEdited = true;
  bool isLoading = false;
  bool isLogedOut = false;
  bool isGuest = false;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();

  String? selectedImage;

  /// Get Profile Data
  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
        _nameController.text = userModel?.name ?? '';
        _emailController.text = userModel?.email ?? '';
        _addressController.text = userModel?.address ?? '';
      });
    } catch (e) {
      String errorMsg = 'Error';
      if (e is ApiErrors) {
        errorMsg = e.message;
      }
      customSnackBar('Error', errorMsg, Colors.red);
    }
  }

  /// Update Profile Data
  Future<void> updateProfileDate() async {
    try {
      setState(() => isLoading = !isLoading);
      final user = await authRepo.updateProfileDate(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        visa: _visaController.text.trim(),
        imagePath: selectedImage,
      );
      setState(() => isLoading = !isLoading);
      customSnackBar(
        'Successful',
        'Profile updated successfully',
        AppColors.primaryColor,
      );
      setState(() => userModel = user);
      await getProfileData();
    } catch (e) {
      setState(() => isLoading = !isLoading);
      String errorMsg = 'Failed to update profile';
      if (e is ApiErrors) errorMsg = e.message;
      customSnackBar('Error', errorMsg, Colors.red);
    }
  }

  /// Pick Image
  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
      });
    }
  }

  /// Log Out
  Future<void> logout() async {
    try {
      await authRepo.logout();
      Get.offAll(() => const LoginView());
    } catch (e) {
      customSnackBar(
        'Error',
        'Failed to log out. Please try again.',
        Colors.red,
      );
    }
  }

  /// Auto Login
  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    if (!mounted) return;
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }

  @override
  void initState() {
    super.initState();
    autoLogin();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isGuest) {
      return RefreshIndicator(
        backgroundColor: AppColors.primaryColor,
        color: Colors.white,
        onRefresh: () async => await getProfileData(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              actions: [
                IconButton(
                  onPressed: () => Get.off(Root()),
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Skeletonizer(
                  enabled: userModel == null,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            border: Border.all(width: 3, color: Colors.white),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: selectedImage != null
                              ? Image.file(
                                  File(selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : (userModel?.image != null &&
                                    userModel!.image!.isNotEmpty)
                              ? Image.network(
                                  userModel!.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, builder) =>
                                      Icon(Icons.person),
                                )
                              : Icon(Icons.person),
                        ),
                      ),
                      const Gap(10),
                      CustomButton(
                        title:
                            (userModel?.image != null &&
                                userModel!.image!.isNotEmpty)
                            ? 'Change Photo'
                            : 'Upload Photo',
                        width: 170,
                        height: 50,
                        fontSize: 16,
                        btnBackground: Colors.white,
                        titleColor: AppColors.primaryColor,
                        onTap: pickImage,
                      ),
                      const Gap(30),
                      CustomUserTextfield(
                        lable: 'Name',
                        controller: _nameController,
                        isEdited: isEdited,
                      ),
                      const Gap(30),
                      CustomUserTextfield(
                        lable: 'Email',
                        controller: _emailController,
                        isEdited: isEdited,
                      ),
                      const Gap(30),
                      CustomUserTextfield(
                        lable: 'Address',
                        controller: _addressController,
                        isEdited: isEdited,
                      ),
                      const Gap(30),
                      const Divider(
                        color: Colors.white,
                        endIndent: 30,
                        indent: 30,
                      ),
                      const Gap(30),
                      userModel?.visa == null
                          ? CustomUserTextfield(
                              lable: 'Add Visa Card',
                              textInputType: TextInputType.number,
                              controller: _visaController,
                              isEdited: isEdited,
                            )
                          : userModel!.visa!.isNotEmpty
                          ? ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              tileColor: Colors.white,
                              leading: Image.asset(ImagePath.visaIcon),
                              title: const CustomText(
                                text: 'Debit Card',
                                color: Colors.black,
                              ),
                              subtitle: CustomText(
                                text: userModel?.visa ?? '**** **** **** 2356',
                                color: Colors.black,
                              ),
                              trailing: const CustomText(
                                text: 'Default',
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            )
                          : const Gap(300),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: Container(
              padding: const EdgeInsets.all(10),
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  isLoading
                      ? Expanded(
                          child: CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      :
                        /// Edit Profile Button
                        CustomProfileBtn(
                          text: isEdited ? 'Edit Profile' : 'Save Changes',
                          icon: CupertinoIcons.pencil,
                          onTap: () {
                            if (!isEdited) updateProfileDate();
                            setState(() => isEdited = !isEdited);
                          },
                          backGroundColor: Colors.white,
                          iconColor: AppColors.primaryColor,
                          borderColor: AppColors.primaryColor,
                          textColor: AppColors.primaryColor,
                        ),
                  const Spacer(),
                  isLogedOut
                      ? Expanded(
                          child: CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : CustomProfileBtn(
                          text: 'Log out',
                          icon: Icons.logout_outlined,
                          onTap: () async {
                            setState(() => isLogedOut = true);
                            await logout();
                            setState(() => isLogedOut = false);
                          },
                          backGroundColor: AppColors.primaryColor,
                          iconColor: Colors.white,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CustomButton(
            width: 200,
            height: 100,
            fontSize: 18,
            btnBackground: AppColors.primaryColor,
            titleColor: Colors.white,
            title: 'Create an account',
            onTap: () => Get.offAll(SignupView()),
          ),
        ),
      );
    }
  }
}
