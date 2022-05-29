import 'package:flutter/material.dart';
import '../Constant/colors.dart';
import 'snack_bar.dart';

snack(BuildContext context, bool isError, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(message, isError ? Icons.close : Icons.done,
        isError ? Colors.red : primaryColor),
  );
}
