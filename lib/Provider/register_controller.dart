import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicross_patient/Model/register_user.dart';

class RegisterController extends ChangeNotifier {
  String? countryCode;
  String? fullName;
  String? email;
  String? city;
  String? phoneNumber;
  String? zoomLink;
  String? specialization;
  String? newPassword;
  String? confirmPassword;
  bool isLoading = false;

  void onChangeCountryCode({String? val}) {
    debugPrint(val);
    if (val != null) {
      countryCode = val;
      notifyListeners();
    }
  }

  void setCity(String? val) {
    city = val == null || val.isEmpty || val == "" ? "Colombo" : val;
    notifyListeners();
  }

  void setFullName({String? value}) {
    fullName = value;
    notifyListeners();
  }

  void setEmail({String? value}) {
    email = value;
    notifyListeners();
  }

  void setPhone({String? value}) {
    debugPrint(countryCode);
    phoneNumber = countryCode ?? "+94" + value.toString();
    notifyListeners();
  }

  void setnewPassword({String? value}) {
    newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword({String? value}) {
    confirmPassword = value;
    notifyListeners();
  }

  void onLoadingChanged(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  RegisterUser onRegister(BuildContext context) {
    RegisterUser registerUser = RegisterUser(
      city: city.toString(),
      email: email.toString(),
      fullName: fullName.toString(),
      password: newPassword.toString(),
      phoneNumber: phoneNumber.toString(),
    );
    return registerUser;
  }
}
