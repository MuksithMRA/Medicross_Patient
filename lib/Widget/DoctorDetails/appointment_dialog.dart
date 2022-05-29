import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicross_patient/Widget/loading.dart';
import 'package:provider/provider.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Constant/colors.dart';
import '../../Model/doctor.dart';
import '../../Model/screen_size.dart';
import '../../Provider/appointment_controller.dart';
import '../../Provider/datetime_controller.dart';
import '../alert_box.dart';
import '../custom_button.dart';
import '../custom_text.dart';
import '../custom_textfield.dart';
import '../snack_bar.dart';
import 'ticker.dart';

class AppointmentDialog extends StatefulWidget {
  final Doctor doctor;
  const AppointmentDialog({Key? key, required this.doctor}) : super(key: key);

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  final TextEditingController _timeField = TextEditingController();
  final TextEditingController _dateField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // late Razorpay _razorpay;

  // @override
  // void initState() {
  //   super.initState();
  //   final provider = Provider.of<AppointmentController>(context, listen: false);
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, provider.handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, provider.handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, provider.handleExternalWallet);
  // }

  @override
  void dispose() {
    _timeField.dispose();
    _dateField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentController>(
      builder: (context, appointment, child) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const CustomText(
                textAlign: TextAlign.center,
                text: "Make an Appointment",
                fontSize: 20),
            content: appointment.isLoading
                ? SizedBox(
                    height: ScreenSize.height * 0.4,
                    width: ScreenSize.width,
                    child: const LoadingWidget())
                : SizedBox(
                    height: ScreenSize.height * 0.6,
                    width: ScreenSize.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const ListTile(
                            title: CustomText(text: "Personal Details"),
                          ),
                          CustomTextField(
                            prefixIcon: Icons.person,
                            hintText: "Patient Name",
                            onChanged: (val) {
                              appointment.setPatientName(val);
                            },
                            validator: (val) {
                              return val == null || val.isEmpty
                                  ? "Please enter patient name"
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            prefixIcon: Icons.numbers,
                            hintText: "Patient Age",
                            onChanged: (val) {
                              try {
                                appointment.setAge(int.parse(val));
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            validator: (val) {
                              int? newVal;
                              try {
                                newVal = int.tryParse(val.toString());
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                              return newVal == null || newVal == 0
                                  ? "Please enter valid patient age"
                                  : null;
                            },
                          ),
                          const ListTile(
                            title: CustomText(
                              text: "Select appointment type",
                            ),
                          ),
                          RadioListTile(
                              title: const CustomText(text: "Online"),
                              value: 0,
                              groupValue: appointment.val,
                              onChanged: (val) {
                                appointment.appointmentTypeOnchange(val);
                              }),
                          RadioListTile(
                            title: const CustomText(text: "Home visit"),
                            value: 1,
                            groupValue: appointment.val,
                            onChanged: (val) {
                              appointment.appointmentTypeOnchange(val);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                              visible: appointment.appointmentType != "Online",
                              child: CustomTextField(
                                onChanged: (val) {
                                  appointment.addressOnChange(val);
                                },
                                maxLines: 1,
                                hintText: "Address",
                                prefixIcon: Icons.home,
                                validator: (val) {
                                  return val == null || val.isEmpty
                                      ? "Please enter address"
                                      : null;
                                },
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const ListTile(
                            title: CustomText(
                              text: "Choose date & time slot",
                            ),
                          ),
                          CustomTextField(
                            validator: (val) {
                              return val == null || val.isEmpty
                                  ? "Please select a date"
                                  : null;
                            },
                            controller: _dateField,
                            readOnly: true,
                            onTap: () {
                              Provider.of<DateTimeController>(context,
                                      listen: false)
                                  .selectDate(context, _dateField);
                            },
                            prefixIcon: Icons.date_range,
                            hintText: "Select Date",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            validator: (val) {
                              return val == null || val.isEmpty
                                  ? "Please select a time slot"
                                  : null;
                            },
                            readOnly: true,
                            controller: _timeField,
                            onTap: () {
                              Provider.of<DateTimeController>(context,
                                      listen: false)
                                  .selecteTime(context, _timeField);
                            },
                            prefixIcon: Icons.timer,
                            hintText: "Select Time",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const ListTile(
                              title:
                                  CustomText(text: "Select number of hours ")),
                          HourTicker(hourlyFee: widget.doctor.hourly_rate),
                          const ListTile(
                            title: CustomText(
                              text: "Note",
                            ),
                          ),
                          CustomTextField(
                            hintText: 'Optional',
                            onChanged: (val) {
                              appointment.noteOnchange(val);
                            },
                            prefixIcon: Icons.edit,
                            maxLines: 4,
                          ),
                          ListTile(
                              title: const CustomText(
                                text: "Total Fee",
                                fontWeight: FontWeight.bold,
                              ),
                              trailing: CustomText(
                                text: "LKR " + appointment.totalFee.toString(),
                                fontWeight: FontWeight.bold,
                              ))
                        ],
                      ),
                    ),
                  ),
            actions: [
              CustomButton(
                text: "Send",
                ontap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (appointment.nofHours > 0) {
                      try {
                        appointment.dateOnchange(_dateField.text);
                        appointment.timeOnchange(_timeField.text);
                        appointment.loadingOnChange(true);

                        CollectionReference appointments = FirebaseFirestore
                            .instance
                            .collection('Appointments');
                        await appointments.add(appointment.onAppointmentSend(
                            widget.doctor.uid, widget.doctor.fullName));
                        await FirebaseFirestore.instance
                            .collection("Notifications")
                            .add(appointment
                                .sendNotification(widget.doctor.uid));
                        appointment.loadingOnChange(false);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(
                                "Apointment sent", Icons.done, primaryColor));
                      } on FirebaseException catch (e) {
                        appointment.loadingOnChange(false);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return AlertBox(
                                  header: "Error", message: e.toString());
                            });
                      } catch (e) {
                        appointment.loadingOnChange(false);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return AlertBox(
                                  header: "Error", message: e.toString());
                            });
                      }
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return const AlertBox(
                                header: "Error",
                                message: "select number of hours");
                          });
                    }
                  }
                },
              ),
              CustomButton(
                text: "Close",
                ontap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
