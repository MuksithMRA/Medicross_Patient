import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widget/custom_text.dart';
import '../Widget/loading.dart';


class Notifications extends StatelessWidget {
  Stream<QuerySnapshot> getNotifications(BuildContext context) async* {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    yield* FirebaseFirestore.instance
        .collection("Notifications")
        .where("toUID", isEqualTo: uid)
        .snapshots();
  }

  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: "Notifications"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: getNotifications(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          int length = snapshot.data.docs.length ?? 0;
          if (length == 0) {
            return const Center(
              child: CustomText(text: "No Notifications"),
            );
          } else {
            return ListView.builder(
              itemCount: length,
              itemBuilder: (BuildContext context, int index) {
                var item = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.comment),
                    title: CustomText(
                      text: item.get("heading"),
                    ),
                    subtitle: CustomText(
                      text: item.get("content"),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
