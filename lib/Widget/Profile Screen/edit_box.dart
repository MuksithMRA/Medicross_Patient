import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicross_patient/Model/screen_size.dart';

import '../../Provider/validations.dart';
import '../custom_button.dart';
import '../custom_text.dart';
import '../custom_textfield.dart';

class EditBox extends StatefulWidget {
  final String content;
  final String data;
  const EditBox({Key? key, required this.content, required this.data})
      : super(key: key);

  @override
  State<EditBox> createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  bool isLoading = false;
  String? fieldData;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: CustomText(text: "Edit ${widget.data}"),
        content: isLoading
            ? SizedBox(
                height: ScreenSize.height * 0.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : CustomTextField(
                validator: (val) {
                  if (widget.content == "Phone") {
                    return ValidationController.isPhoneNumberValid(val);
                  } else {
                    return ValidationController.isFullNameValid(val);
                  }
                },
                initialValue: widget.content,
                onChanged: (val) {
                  setState(() {
                    fieldData = val;
                  });
                },
                prefixIcon: widget.data == "Phone" ? Icons.phone : Icons.person,
              ),
        actions: [
          CustomButton(
            text: "Update",
            ontap: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  if (widget.data == "Phone") {
                    await FirebaseFirestore.instance
                        .collection('patients')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({'phone': '$fieldData'});
                  } else {
                    await FirebaseAuth.instance.currentUser!
                        .updateDisplayName(fieldData.toString());
                    await FirebaseFirestore.instance
                        .collection('patients')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({'fullName': '$fieldData'});
                  }

                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint(e.toString());
                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
          ),
          CustomButton(
            text: "Close",
            ontap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
