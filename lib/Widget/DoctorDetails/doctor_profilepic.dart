import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Model/doctor.dart';
import '../../Model/screen_size.dart';

class DoctorProfilePic extends StatelessWidget {
  final Doctor doctor;
  const DoctorProfilePic({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.height * 0.3,
      width: ScreenSize.width,
      child: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: ScreenSize.width,
            height: ScreenSize.height * 0.2,
          ),
          SizedBox(
            width: ScreenSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("doctors")
                      .where('uid', isEqualTo: doctor.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data?.docs.first.get('profilePic')),
                      radius: ScreenSize.width * 0.2,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
