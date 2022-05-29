import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Animation/page_transition_slide.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Screen/notifications.dart';
import '../../Service/database_service.dart';
import '../custom_text.dart';


class TopWelcomeTiles extends StatelessWidget {
  const TopWelcomeTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User _auth = FirebaseAuth.instance.currentUser!;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSize.height * 0.035,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_auth.photoURL ?? ''),
        ),
        title: CustomText(
          text: "Hello ${_auth.displayName.toString().split(' ')[0]}",
          fontWeight: FontWeight.bold,
        ),
        subtitle: const CustomText(text: "How're you today?"),
        trailing: IconButton(
          icon: StreamBuilder<QuerySnapshot>(
            stream: DatabaseService.notificationCount(context, false),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? Badge(
                      badgeContent: CustomText(
                          color: kwhite,
                          text: snapshot.data?.docs.length.toString() ??
                              0.toString()),
                      child: const Icon(
                        Icons.notifications,
                        size: 30,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
          onPressed: () async {
            DatabaseService.setAllRead();
            Navigator.push(context, SlideTransition1(const Notifications()));
          },
        ),
      ),
    );
  }
}