import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constant/colors.dart';
import '../../Model/doctor.dart';
import '../../Provider/appointment_controller.dart';
import '../alert_box.dart';
import '../custom_button.dart';
import 'appointment_dialog.dart';

class DoctorOptionBar extends StatefulWidget {
  final Doctor doctor;
  const DoctorOptionBar({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorOptionBar> createState() => _DoctorOptionBarState();
}

class _DoctorOptionBarState extends State<DoctorOptionBar> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppointmentController>(context, listen: false)
        .isFavorite(widget.doctor.uid);
  }

  @override
  Widget build(BuildContext context) {
    final appointmentCtrl =
        Provider.of<AppointmentController>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ButtonBar(
        children: [
          FloatingActionButton(
              backgroundColor: kwhite,
              onPressed: () {
                appointmentCtrl.loadingOnChange(true);
                appointmentCtrl.onFav(widget.doctor);
                appointmentCtrl.loadingOnChange(false);
              },
              child: appointmentCtrl.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Icon(
                      appointmentCtrl.favIcon,
                      color: appointmentCtrl.favColor,
                      size: 30,
                    )),
          FloatingActionButton(
            onPressed: () async {
              String url = "tel:${widget.doctor.phone}";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw "Could not launch $url";
              }
            },
            child: const Icon(Icons.call),
          ),
          FloatingActionButton(
            onPressed: () async {
              String url =
                  "mailto:${widget.doctor.email}?subject=<subject>&body=<body>";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw "Could not launch $url";
              }
            },
            child: const Icon(Icons.mail),
          ),
          CustomButton(
            text: "Make and appointment",
            ontap: () {
              if (widget.doctor.availability) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return AppointmentDialog(
                      doctor: widget.doctor,
                    );
                  },
                );
              } else {
                showDialog(
                    context: context,
                    builder: (_) {
                      return const AlertBox(
                          header: "Error", message: "This doctor is busy");
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}
