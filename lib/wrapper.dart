import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_patient/Screen/verify_email.dart';
import 'package:medicross_patient/Widget/custom_text.dart';
import 'package:provider/provider.dart';
import 'Model/screen_size.dart';
import 'Provider/check_connectivity.dart';
import 'Provider/login_ controller.dart';
import 'Screen/home.dart';
import 'Screen/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    ScreenSize.setScreenSize(h: screenSize.height, w: screenSize.width);
    final connection = Provider.of<CheckConnectivity>(context, listen: true);

    return Consumer<LoginController>(
      builder: (context, loginCtrl, child) {
        loginCtrl.setLoginState();
        if (connection.isConnectionSuccessful ||
            connection.connectivityResult != ConnectivityResult.none) {
          if (loginCtrl.isLoggedIn) {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              return const HomePage();
            } else {
              return const VerifyEmail();
            }
          } else {
            return const Login();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CustomText(text: "No internet"),
            ),
          );
        }
      },
    );
  }
}
