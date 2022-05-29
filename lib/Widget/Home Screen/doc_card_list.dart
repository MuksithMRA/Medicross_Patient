import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/doctor.dart';
import '../../Provider/homepage_controller.dart';
import '../../Service/database_service.dart';
import '../custom_text.dart';
import '../loading.dart';
import 'doc_card.dart';

class DocCardList extends StatelessWidget {
  const DocCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageController>(
        builder: (context, homepageCtrl, child) {
      return Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService.getAllDoctors(
              context, homepageCtrl.specialization, homepageCtrl.searchText),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.data?.docs == null ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                child: CustomText(text: "No Doctors"),
              );
            }
            return GridView.builder(
              
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3/3.7,
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
      
                return DocCard(
                  doctor: Doctor.fromMap(data),
                );
              },
            );
          },
        ),
      );
    });
  }
}
