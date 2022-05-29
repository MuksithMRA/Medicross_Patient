import 'package:flutter/material.dart';
import 'package:medicross_patient/Provider/register_controller.dart';
import 'package:provider/provider.dart';

import '../../Model/screen_size.dart';
import '../custom_text.dart';

class SetCity extends StatelessWidget {
  const SetCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
        builder: (context, registerController, child) {
      return Row(
        children: [
          const Flexible(
            child: CustomText(
              text: "Select City ",
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: ScreenSize.width * 0.1,
          ),
          Flexible(
            child: DropdownButton<String>(
              value: registerController.city ?? "Colombo",
              items: <String>['Colombo', 'Galle', 'Matara', 'Gampaha']
                  .map((String e) {
                return DropdownMenuItem(
                    value: e,
                    child: CustomText(
                      fontSize: 18,
                      text: e.toString(),
                    ));
              }).toList(),
              onChanged: (String? val) {
                registerController.setCity(val);
              },
            ),
          ),
        ],
      );
    });
  }
}
