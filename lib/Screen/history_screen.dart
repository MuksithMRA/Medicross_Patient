import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicross_patient/Animation/straggered_list.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_text.dart';
import '../Model/Appointment.dart';
import '../Service/database_service.dart';
import '../Widget/custom_button.dart';
import '../Widget/loading.dart';
import '../Widget/snack_bar.dart';

class History extends StatelessWidget {
  Stream<QuerySnapshot> getAllAppointments(BuildContext context) async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection("Appointments")
        .where('fromUID', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  const History({Key? key}) : super(key: key);

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
            text: "Consultation History",
            fontSize: 25,
          ),
          SizedBox(
              height: ScreenSize.height * 0.745,
              child: StreamBuilder(
                  stream: getAllAppointments(context),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingWidget();
                    } else if (snapshot.hasData) {
                      int length = snapshot.data?.docs.length ?? 0;
                      if (length != 0) {
                        return ListView.builder(
                          itemCount: length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = snapshot.data?.docs[index];
                            debugPrint(
                                item?.get("createdAt").runtimeType.toString());
                            return CustomStaggeredList(
                                index: index,
                                child: ConsultationCard(
                                  appointment: Appointment(
                                      address: item?.get('address'),
                                      doctorName: item?.get("doctorName"),
                                      createdAt: item?.get("createdAt"),
                                      appointmentType:
                                          item?.get("AppointmentType"),
                                      fromUID: item?.get("fromUID"),
                                      toUID: item?.get("toUID"),
                                      date: item?.get("Date"),
                                      time: item?.get("Time"),
                                      note: item?.get("Note"),
                                      status: item?.get("Status"),
                                      totalFee:
                                          double.parse(item?.get("totalFee")),
                                      patientName: item?.get("patientName"),
                                      patientAge: item?.get("patientAge"),
                                      ref: snapshot
                                          .data?.docs[index].reference.id),
                                ));
                          },
                        );
                      } else {
                        return const Center(
                          child: CustomText(text: "No Appointments"),
                        );
                      }
                    }
                    return Center(
                      child: CustomText(
                        text: snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

class ConsultationCard extends StatefulWidget {
  final Appointment appointment;
  const ConsultationCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<ConsultationCard> createState() => _ConsultationCardState();
}

class _ConsultationCardState extends State<ConsultationCard> {
  @override
  void initState() {
    super.initState();
    final db = Provider.of<DatabaseService>(context, listen: false);
    db.getUserField("doctors", widget.appointment.toUID, "fullName");
  }

  @override
  Widget build(BuildContext context) {
    //print(db.userName);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        color: kwhite,
        child: SizedBox(
          height: widget.appointment.status == "Accepted"
              ? ScreenSize.height * 0.35
              : ScreenSize.height * 0.3,
          child: Column(
            children: [
              ListTile(
                leading: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("doctors")
                      .where('uid', isEqualTo: widget.appointment.toUID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Image.network(
                      snapshot.data?.docs.first.get("profilePic"),
                      fit: BoxFit.fill,
                    );
                  },
                ),
                title: CustomText(text: widget.appointment.doctorName),
                subtitle:
                    CustomText(text: widget.appointment.createdAt.toString()),
                trailing: widget.appointment.status == "Rejected"
                    ? const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: kwhite),
                      )
                    : widget.appointment.status == "Accepted"
                        ? const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.done, color: kwhite),
                          )
                        : const CircleAvatar(
                            child: Icon(FontAwesomeIcons.clock, color: kwhite),
                          ),
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: const CustomText(text: "Patient Name"),
                      subtitle:
                          CustomText(text: widget.appointment.patientName),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      title: const CustomText(text: "Consultation Type"),
                      subtitle:
                          CustomText(text: widget.appointment.appointmentType),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: const CustomText(text: "Service Fee"),
                      subtitle: CustomText(
                          text:
                              "LKR " + widget.appointment.totalFee.toString()),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      title: const CustomText(text: "Status"),
                      subtitle: CustomText(
                        text: widget.appointment.status,
                        color: widget.appointment.status == "Rejected"
                            ? Colors.red
                            : widget.appointment.status == "Accepted"
                                ? primaryColor
                                : kBlack,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              widget.appointment.status == "Accepted" &&
                      widget.appointment.appointmentType == "Online"
                  ? CustomButton(
                      width: ScreenSize.width * 0.8,
                      text: "Copy Meeting link",
                      ontap: () async {
                        try {
                          String _url = await FirebaseFirestore.instance
                              .collection("Appointments")
                              .doc(widget.appointment.ref)
                              .get()
                              .then((value) {
                            return value.get("meeting_link");
                          });

                          Clipboard.setData(ClipboardData(text: _url));

                          ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar("Meeting link Copied", Icons.done,
                                  primaryColor));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar("Something went wrong",
                                  Icons.warning, Colors.red));
                        }
                      },
                    )
                  : widget.appointment.status == "Accepted" &&
                          widget.appointment.appointmentType == "Home visit"
                      ? ListTile(
                          leading: const Icon(
                            Icons.home,
                            color: primaryColor,
                          ),
                          title: CustomText(
                              text: "Meet at : ${widget.appointment.address}"),
                        )
                      : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
