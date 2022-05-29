import 'package:flutter/material.dart';
import 'package:medicross_patient/Provider/appointment_controller.dart';
import 'package:medicross_patient/Widget/custom_text.dart';
import 'package:provider/provider.dart';

class HourTicker extends StatelessWidget {
  final double hourlyFee;
  const HourTicker({Key? key, required this.hourlyFee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentController>(
      builder: (context, appointment, child) {
        return Row(
          children: [
            FloatingActionButton.small(
              onPressed: () {
                appointment.hourDec();
                appointment.calculateHourlyFee(hourlyFee);
              },
              child: const CustomText(text: "-"),
            ),
            const SizedBox(
              width: 10,
            ),
            CustomText(text: appointment.nofHours.toString()),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton.small(
              onPressed: () {
                appointment.hourInc();
                appointment.calculateHourlyFee(hourlyFee);
              },
              child: const CustomText(text: "+"),
            ),
          ],
        );
      },
    );
  }
}
