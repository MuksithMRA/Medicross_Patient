import 'package:flutter/material.dart';
import 'package:medicross_patient/Widget/Register/headings.dart';
import 'package:medicross_patient/Widget/Register/phone_number.dart';
import 'package:medicross_patient/Widget/Register/set_city.dart';
import 'package:provider/provider.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_text.dart';
import '../../Widget/custom_textfield.dart';
import '../Provider/error_provider.dart';
import '../Provider/homepage_controller.dart';
import '../Provider/register_controller.dart';
import '../Provider/validations.dart';
import '../Service/auth.dart';
import '../Widget/loading.dart';
import '../Widget/loading_dialog.dart';
import '../Widget/snack_bar.dart';
import 'verify_email.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, regcontroller, child) {
        return Scaffold(
          body: regcontroller.isLoading
              ? const LoadingWidget()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ScreenSize.height * 0.03,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenSize.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const MainHeading(),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),
                                const SubHeading(),
                                SizedBox(
                                  height: ScreenSize.height * 0.04,
                                ),

                                //Full Name
                                CustomTextField(
                                  prefixIcon: Icons.person,
                                  labelText: "Full Name",
                                  onChanged: (String? value) {
                                    regcontroller.setFullName(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController.isFullNameValid(
                                        val);
                                  },
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Email
                                CustomTextField(
                                  prefixIcon: Icons.mail,
                                  labelText: "Email",
                                  onChanged: (String? value) {
                                    regcontroller.setEmail(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController
                                        .isEmailValidated(val);
                                  },
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Select City
                                const SetCity(),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Select phone number
                                const PhoneNumberField(),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //New Password
                                CustomTextField(
                                  isPassword: true,
                                  onChanged: (String? value) {
                                    regcontroller.setnewPassword(value: value);
                                  },
                                  validator: (val) {
                                    return ValidationController
                                        .isNewPassValidated(val);
                                  },
                                  prefixIcon: Icons.lock_open,
                                  labelText: "New Password",
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),

                                //Confirm Password
                                CustomTextField(
                                    isPassword: true,
                                    validator: (val) {
                                      return ValidationController
                                          .isConfirmPassValidated(
                                              regcontroller.newPassword, val);
                                    },
                                    onChanged: (String? value) {
                                      regcontroller.setConfirmPassword(
                                          value: value);
                                    },
                                    prefixIcon: Icons.lock,
                                    labelText: "Confirm Password"),
                                SizedBox(
                                  height: ScreenSize.height * 0.05,
                                ),

                                //Register Button
                                CustomButton(
                                  ontap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      AuthService _auth = AuthService();
                                      showLoaderDialog(context);
                                      String? result = await _auth
                                          .signUpWithEmailAndPassword(
                                              regcontroller
                                                  .onRegister(context));
                                      Navigator.pop(context);
                                      if (result == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(customSnackBar(
                                                ErrorProvider.message,
                                                Icons.warning,
                                                Colors.red));
                                      } else {
                                        try {
                                          Provider.of<HomePageController>(
                                                  context,
                                                  listen: false)
                                              .onBottomNavItemChange(0);
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const VerifyEmail()),
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    }
                                  },
                                  text: "Register",
                                  width: ScreenSize.width,
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.05,
                                ),
                                const CustomText(
                                  text:
                                      "By clicking Register you are agreeing to the Terms of use and the Privacy Policy",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
