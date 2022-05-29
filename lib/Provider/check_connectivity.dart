import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class CheckConnectivity extends ChangeNotifier {
  ConnectivityResult? connectivityResult;
  StreamSubscription? connectivitySubscription;
  bool isConnectionSuccessful = false;

  //check connectivity state
  Future<void> checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      debugPrint('Connected to a Wi-Fi network');
    } else if (result == ConnectivityResult.mobile) {
      debugPrint('Connected to a mobile network');
    } else {
      debugPrint('Not connected to any network');
    }

    connectivityResult = result;
    notifyListeners();
  }

  //check connectivity state change
  Future<void> connectivityStateChange() async {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        connectivityResult = result;
        notifyListeners();
      },
    );
  }

  //get successfully connected or not
  Future<void> tryConnection() async {
    try {
      final response = await InternetAddress.lookup('https://www.google.com/');
      debugPrint(response.toString());
      isConnectionSuccessful = true;
      notifyListeners();
    } on SocketException catch (e) {
      debugPrint(e.toString());
      isConnectionSuccessful = false;
      notifyListeners();
    }
  }
}
