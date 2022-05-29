import 'package:flutter/material.dart';


class DoctorAvailability extends StatelessWidget {
  final bool isAvailable;
  const DoctorAvailability({Key? key, required this.isAvailable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isAvailable) {
      return RichText(
        text: const TextSpan(
          children: [
            WidgetSpan(
                child: Icon(
              Icons.event_available,
              color: Colors.green,
            )),
            TextSpan(
                style: TextStyle(color: Colors.green, fontSize: 15),
                text: ' Available '),
          ],
        ),
      );
    }
    return RichText(
      text: const TextSpan(
        children: [
          WidgetSpan(
              child: Icon(
            Icons.event_busy,
            color: Colors.red,
          )),
          TextSpan(
              style: TextStyle(color: Colors.red, fontSize: 15), text: ' Busy'),
        ],
      ),
    );
  }
}