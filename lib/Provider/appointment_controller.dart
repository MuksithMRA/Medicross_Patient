import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../Constant/colors.dart';
import '../Model/Appointment.dart';
import '../Model/doctor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/notification.dart';

class AppointmentController extends ChangeNotifier {
  String appointmentType = "Online";
  Object val = 0;
  String? date;
  String? time;
  String note = "";
  bool isLoading = false;
  Appointment? appointment;
  int nofHours = 0;
  double totalFee = 0;
  String? patientName;
  int patientAge = 0;
  IconData favIcon = Icons.star_border;
  Color favColor = kBlack;
  bool isFav = false;
  String? address;
  bool isPaid = false;

  Future<void> isFavorite(String docUid) async {
    String? _uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("care_team")
        .where("uid", isEqualTo: _uid)
        .where("doc_uid", isEqualTo: docUid)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        isFav = true;
        notifyListeners();
      } else {
        isFav = false;
        notifyListeners();
      }
    });

    if (isFav) {
      favIcon = Icons.star;
      favColor = Colors.yellow;
    } else {
      favIcon = Icons.star_border;
      favColor = kBlack;
    }
  }

  onFav(Doctor doctor) async {
    User _auth = FirebaseAuth.instance.currentUser!;
    if (!isFav) {
      try {
        await FirebaseFirestore.instance.collection("care_team").add({
          "doctor": doctor.toMap(),
          "uid": _auth.uid,
          "doc_uid": doctor.uid
        });
        favIcon = Icons.star;
        favColor = Colors.yellow;
        isFav = true;
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
     
      try {
        await FirebaseFirestore.instance
            .collection("care_team")
            .where('uid', isEqualTo: _auth.uid)
            .where('doc_uid', isEqualTo: doctor.uid)
            .get()
            .then((value) {
          value.docs.first.reference.delete();
        });
        favIcon = Icons.star_border;
        favColor = kBlack;
        isFav = false;
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  setPatientName(String? name) {
    patientName = name;
    notifyListeners();
  }

  setAge(int age) {
    patientAge = age;
    notifyListeners();
  }

  calculateHourlyFee(double hourlyFee) {
    totalFee = hourlyFee * nofHours;
    notifyListeners();
  }

  hourInc() {
    nofHours = nofHours + 1;
    notifyListeners();
  }

  hourDec() {
    if (nofHours > 0) {
      nofHours = nofHours - 1;
      notifyListeners();
    }
  }

  loadingOnChange(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  appointmentTypeOnchange(val) {
    if (val != null) {
      this.val = val;
      appointmentType = val == 0 ? "Online" : "Home visit";
      notifyListeners();
    }
  }

  addressOnChange(String? val) {
    address = val;
    notifyListeners();
  }

  dateOnchange(String val) {
    date = val;
    notifyListeners();
  }

  timeOnchange(String val) {
    time = val;
    notifyListeners();
  }

  noteOnchange(String val) {
    note = val;
    notifyListeners();
  }

  onAppointmentSend(String toUID, String docName) {
    appointment = Appointment(
      appointmentType: appointmentType,
      fromUID: FirebaseAuth.instance.currentUser!.uid,
      toUID: toUID,
      patientAge: patientAge,
      patientName: patientName.toString(),
      date: date.toString(),
      time: time.toString(),
      note: note.toString(),
      status: "Pending",
      totalFee: totalFee,
      createdAt: DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now()),
      doctorName: docName,
      address: address,
    );
    debugPrint(appointment!.address);
    return {
      "AppointmentType": appointment!.appointmentType,
      "patientName": appointment!.patientName,
      "patientAge": appointment!.patientAge,
      "fromUID": appointment!.fromUID,
      "toUID": appointment!.toUID,
      "Date": appointment!.date,
      "Time": appointment!.time,
      "Note": appointment!.note,
      "Status": appointment!.status,
      "totalFee": appointment!.totalFee.toString(),
      "createdAt": appointment!.createdAt,
      "doctorName": appointment!.doctorName,
      "address": appointment!.address.toString()
    };
  }

  sendNotification(String docUID) {
    NotificationModel notification = NotificationModel(
      heading: "New Appointment",
      content: "you have recieved new Appointment from $patientName",
      toUID: docUID,
      fromUID: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now()),
    );

    return {
      "heading": notification.heading,
      "content": notification.content,
      "toUID": notification.toUID,
      "fromUID": notification.fromUID,
      "createdAt": notification.createdAt
    };
  }

//==================================payment handeling================================

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Success Response: ${response.orderId}');
    isPaid = true;
    notifyListeners();
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: $response');
    isPaid = false;
    notifyListeners();
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);

    debugPrint(response.message..toString());
  }

  Future<void> openCheckout(
      {required int amount,
      required String phone,
      required String email,
      required Razorpay razorpay}) async {
    var orderId = await generateOrderId(
        "rzp_test_W3L88kj60djKYd", "NydgdslBSPU3Xy4VdokI3csv", amount);
    var options = {
      'key': 'rzp_test_W3L88kj60djKYd',
      'amount': amount * 100,
      'order_id': orderId,
      "currency": "USD",
      'name': 'Doctor Name',
      "international": true,
      'description': 'Appointment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': phone, 'email': email},
      "base_currency": "LKR",
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<String> generateOrderId(String key, String secret, int amount) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": ${amount * 100}, "currency": "LKR", "receipt": "receipt#R1", "payment_capture": 1}';
    // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!
    // ignore: prefer_typing_uninitialized_variables
    var res;
    try {
      res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
          headers: headers, body: data);
      if (res.statusCode != 200) {
        throw Exception('http.post error: statusCode= ${res.statusCode}');
      }
      debugPrint('ORDER ID response => ${res.body}');
    } catch (e) {
      debugPrint(e.toString());
    }

    return json.decode(res.body)['id'].toString();
  }
}
