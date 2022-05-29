import 'package:flutter/material.dart';
import '../../Animation/page_transition_slide.dart';
import '../../Constant/colors.dart';
import '../../Model/doctor.dart';
import '../../Model/screen_size.dart';
import '../../Screen/doctor_details.dart';
import '../custom_text.dart';

class DocCard extends StatelessWidget {
  final Doctor doctor;
  const DocCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                SlideTransition1(DoctorDetails(
                  doctor: doctor,
                )));
          },
          child: Card(
            elevation: 10,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      radius: ScreenSize.width * 0.1,
                      backgroundImage:
                          NetworkImage(doctor.profilePic.toString()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: CustomText(
                      text: doctor.fullName,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Expanded(
                    child: CustomText(
                      text: doctor.specialization,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                              child: Icon(
                            Icons.location_city,
                            color: primaryColor,
                          )),
                          TextSpan(
                              style: const TextStyle(color: kBlack),
                              text: doctor.city),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        doctor.availability
                            ? const Icon(
                                Icons.event_available,
                                color: primaryColor,
                              )
                            : const Icon(
                                Icons.event_busy,
                                color: Colors.red,
                              ),
                        SizedBox(
                          width: ScreenSize.width * 0.01,
                        ),
                        doctor.availability
                            ? const CustomText(
                                text: "Available",
                                color: primaryColor,
                              )
                            : const CustomText(
                                text: "Unavailable",
                                color: Colors.red,
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
