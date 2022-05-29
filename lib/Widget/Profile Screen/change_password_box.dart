import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_patient/Constant/colors.dart';
import 'package:medicross_patient/Model/screen_size.dart';
import 'package:medicross_patient/Provider/error_provider.dart';
import 'package:medicross_patient/Provider/validations.dart';
import 'package:medicross_patient/Service/auth.dart';
import 'package:medicross_patient/Widget/custom_button.dart';
import 'package:medicross_patient/Widget/custom_text.dart';
import 'package:medicross_patient/Widget/custom_textfield.dart';
import 'package:medicross_patient/Widget/snack_bar.dart';

import '../../Screen/login.dart';

class ChangePasswordBox extends StatefulWidget {
  const ChangePasswordBox({Key? key}) : super(key: key);

  @override
  State<ChangePasswordBox> createState() => _ChangePasswordBoxState();
}

class _ChangePasswordBoxState extends State<ChangePasswordBox> {
  final _formKey = GlobalKey<FormState>();
  String? currentPassword;
  String? newPassword;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: AlertDialog(
          title: const CustomText(
            text: "Change Password",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: ScreenSize.height * 0.255,
            width: ScreenSize.width * 0.9,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      CustomTextField(
                        validator: (val) {
                          return ValidationController.isNewPassValidated(val);
                        },
                        hintText: "Current Password",
                        prefixIcon: Icons.lock_open,
                        isPassword: true,
                        onChanged: (val) {
                          setState(() {
                            currentPassword = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        validator: (val) {
                          return ValidationController.isNewPassValidated(val);
                        },
                        hintText: "New Password",
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        onChanged: (val) {
                          setState(() {
                            newPassword = val;
                          });
                        },
                      ),
                    ],
                  ),
          ),
          actions: [
            CustomButton(
              text: "Change",
              ontap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  await AuthService().changePassword(
                      currentPassword.toString(), newPassword.toString());

                  if (FirebaseAuth.instance.currentUser?.uid != null) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      ErrorProvider.message,
                      Icons.warning,
                      Colors.red,
                    ));
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                        "Password changed , please login again",
                        Icons.done,
                        primaryColor));
                  }

                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
            CustomButton(
              text: "Cancel",
              ontap: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}
