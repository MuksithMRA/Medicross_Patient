import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Widget/custom_text.dart';
import '../Service/database_service.dart';
import '../Provider/homepage_controller.dart';
import '../Service/auth.dart';
import '../Widget/Profile Screen/menu_list.dart';
import '../Widget/Profile Screen/profile_picture.dart';
import '../Widget/snack_bar.dart';
import 'login.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseService>(
      builder: (context, db, child) {
        db.getProfileDetails();
        return SingleChildScrollView(
          child: SizedBox(
            width: ScreenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.06,
                ),
                const ProfilePicture(),
                SizedBox(
                  height: ScreenSize.height * 0.02,
                ),
                CustomText(
                  text: db.name ?? "Loading ...",
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                MenuList(
                  phone: db.phone ?? "Loading ...",
                  name: db.name ?? "Loading ...",
                  notifications: const [],
                ),
                ListTile(
                  onTap: () async {
                    try {
                      String? result = await AuthService().signOut();
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(
                                "Log out failed", Icons.warning, Colors.red));
                      } else {
                        db.setNull();
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (Route<dynamic> route) => false,
                        );
                        try {
                          Provider.of<HomePageController>(context,
                                  listen: false)
                              .onBottomNavItemChange(0);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }
                    } catch (e) {
                      debugPrint("Exception : $e");
                    }
                  },
                  leading: const Icon(
                    Icons.logout,
                    color: primaryColor,
                  ),
                  title: const CustomText(text: "Logout"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
