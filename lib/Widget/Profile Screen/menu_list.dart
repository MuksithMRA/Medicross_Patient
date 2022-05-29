import 'package:flutter/material.dart';
import '../../Constant/colors.dart';
import '../../Model/profile_menu_list.dart';
import '../custom_text.dart';
import 'change_password_box.dart';
import 'edit_box.dart';

class MenuList extends StatelessWidget {
  final String name;
  final String phone;
  final List notifications;
  const MenuList(
      {Key? key,
      required this.name,
      required this.phone,
      required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProfileMenuItem> profileMenuItems = [
      ProfileMenuItem(
          icon: Icons.person,
          title: "Profile Settings",
          listOfWidgets: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const CustomText(text: "Name"),
              subtitle: CustomText(text: name),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return EditBox(content: name, data: "Name");
                      });
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const CustomText(text: "Phone number"),
              subtitle: CustomText(text: phone),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return EditBox(content: phone, data: "Phone");
                      });
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ]),
      ProfileMenuItem(
          icon: Icons.lock,
          title: "Manage Passwords",
          listOfWidgets: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const CustomText(text: "Password"),
              subtitle: const CustomText(text: "*********"),
              trailing: IconButton(
                onPressed: () async {
                  // AuthService().changePassword("nimal123", "nimal1234");
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return const ChangePasswordBox();
                      });
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ]),
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profileMenuItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          children: profileMenuItems[index].listOfWidgets,
          leading: Icon(
            profileMenuItems[index].icon,
            color: primaryColor,
          ),
          title: CustomText(text: profileMenuItems[index].title),
        );
      },
    );
  }
}
