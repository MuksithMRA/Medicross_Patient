import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../Screen/history_screen.dart';
import '../Screen/home_screen.dart';
import '../Screen/my_team_screen.dart';
import '../Screen/profile_screen.dart';
import '../Service/database_service.dart';

class HomePageController extends ChangeNotifier {
  Map<String, dynamic>? details;
  int currentIndex = 0;
  String? specialization;
  List<Widget> listOfScreens = const [
    Home(),
    History(),
    MyTeam(),
    Profile(),
  ];
  String? searchText;

  searchOnChange(String? searchText) {
    this.searchText = searchText;
    notifyListeners();
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.history_rounded,
    Icons.group_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'History',
    'My Team',
    'Account',
  ];

  void onBottomNavItemChange(int index) {
    currentIndex = index;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void getRecentAppointment(
      QuerySnapshot<Object?> event, BuildContext context) async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    await db.getUserField("doctors", event.docs.first.get("toUID"), "fullName");
    details = {
      "date": event.docs.first.get("Date"),
      "time": event.docs.first.get("Time"),
      "docName": "Doctor " + db.userName.toString()
    };

    notifyListeners();
  }

  void setSpecialization(String? spec) {
    specialization = spec;
    notifyListeners();
  }
}
