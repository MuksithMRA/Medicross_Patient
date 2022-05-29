import 'package:flutter/material.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../Animation/page_transition_slide.dart';
import '../Model/doctor.dart';
import '../Screen/doctor_details.dart';
import 'custom_text.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: kwhite,
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        child: SizedBox(
          width: ScreenSize.width,
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  SlideTransition1(DoctorDetails(
                    doctor: doctor,
                  )));
            },
            leading: doctor.profilePic == null
                ? const CircularProgressIndicator()
                : Image.network(
                    doctor.profilePic ?? "",
                    fit: BoxFit.fill,
                  ),
            title: CustomText(text: doctor.fullName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Specialized In ${doctor.specialization}"),
                RichText(
                    text: TextSpan(children: [
                  const WidgetSpan(
                      child: Icon(
                    Icons.location_city,
                    color: primaryColor,
                  )),
                  TextSpan(
                      style: const TextStyle(color: kBlack), text: doctor.city),
                ])),
                SizedBox(
                  height: ScreenSize.height * 0.02,
                ),
              ],
            ),
            trailing: Column(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      doctor.availability
                          ? Icons.event_available
                          : Icons.event_busy,
                      color: doctor.availability ? primaryColor : Colors.red,
                    ),
                    CustomText(
                      text: doctor.availability ? "Available" : "Busy",
                      color: doctor.availability ? primaryColor : Colors.red,
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


