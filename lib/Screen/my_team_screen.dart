import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicross_patient/Model/doctor.dart';
import 'package:medicross_patient/Service/database_service.dart';
import 'package:medicross_patient/Widget/doctor_card.dart';
import 'package:medicross_patient/Widget/loading.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_text.dart';

class MyTeam extends StatelessWidget {


  const MyTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenSize.height * 0.08,
          ),
          const CustomText(
            text: "My Care Team",
            fontSize: 25,
          ),
          SizedBox(
            height: ScreenSize.height * 0.745,
            child: StreamBuilder<QuerySnapshot>(
              stream:DatabaseService.getMyCareTeam(context),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                int length = snapshot.data?.docs.length ?? 0;
                if (length == 0) {
                  return const Center(
                    child: CustomText(
                      text: "No Doctors",
                    ),
                  );
                } else {
                  return ListView(
                    children:
                        snapshot.data?.docs.map((DocumentSnapshot snapshot) {
                              Map<String, dynamic> data =
                                  snapshot.data()! as Map<String, dynamic>;
                              return DoctorCard(
                                  doctor: Doctor.fromMap(data['doctor']));
                            }).toList() ??
                            [],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
