import 'package:flutter/material.dart';
import '../../Model/doctor.dart';
import '../custom_text.dart';

class DetailsTiles extends StatelessWidget {
  final Doctor doctor;
  const DetailsTiles({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        ListTile(
          title: const CustomText(text: "Specialization"),
          subtitle: CustomText(text: doctor.specialization),
        ),
        ListTile(
          title: const CustomText(text: "Hourly Rate"),
          subtitle: CustomText(text: "LKR " + doctor.hourly_rate.toString()),
        ),
        ListTile(
          title: const CustomText(text: "City"),
          subtitle: CustomText(text: doctor.city),
        ),
        ListTile(
          title: const CustomText(text: "Email"),
          subtitle: CustomText(text: doctor.email),
        ),
      ],
    );
  }
}
