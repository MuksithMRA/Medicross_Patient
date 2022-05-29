import 'package:flutter/material.dart';

import '../../Constant/colors.dart';
import '../../Screen/login.dart';
import '../custom_text.dart';

class MainHeading extends StatelessWidget {
  const MainHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomText(
      text: "Welcome to Medical Cross App",
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }
}

class SubHeading extends StatelessWidget {
  const SubHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomText(
          text: "Already have an account? ",
          fontSize: 16,
        ),
        CustomText(
          text: "Log In",
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (Route<dynamic> route) => false,
            );
          },
          color: primaryColor,
          fontSize: 16,
        )
      ],
    );
  }
}
