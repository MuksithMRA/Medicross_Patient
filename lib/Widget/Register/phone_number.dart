import 'package:flutter/material.dart';
import 'package:medicross_patient/Provider/register_controller.dart';
import 'package:provider/provider.dart';

import '../../Provider/validations.dart';
import '../custom_text.dart';
import '../custom_textfield.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
        builder: (context, registerController, child) {
      return Row(
        children: [
          Flexible(
            child: DropdownButton<String>(
              value: registerController.countryCode ?? "+94",
              items: <String>['+94', '+91', '+1'].map((String e) {
                return DropdownMenuItem(
                    value: e,
                    child: CustomText(
                      fontSize: 18,
                      text: e.toString(),
                    ));
              }).toList(),
              onChanged: (String? val) {
                registerController.onChangeCountryCode(val: val);
              },
            ),
          ),
          Flexible(
              flex: 5,
              child: CustomTextField(
                  validator: (val) {
                    return ValidationController.isPhoneNumberValid(val);
                  },
                  onChanged: (String? value) {
                    registerController.setPhone(value: value);
                  },
                  prefixIcon: Icons.phone,
                  labelText: "Phone Number")),
        ],
      );
    });
  }
}
