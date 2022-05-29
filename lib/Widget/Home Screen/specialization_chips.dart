import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Provider/homepage_controller.dart';
import '../../Service/database_service.dart';
import '../custom_text.dart';

class SpecializationChips extends StatelessWidget {
 

  const SpecializationChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageController>(
      builder: (context, homepageCtrl, child) {
        return SizedBox(
          height: ScreenSize.height * 0.04,
          child: StreamBuilder(
            stream: DatabaseService.getAllCategories(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(left: ScreenSize.width * 0.07),
                        child: InkWell(
                          onTap: () {
                            homepageCtrl.setSpecialization(null);
                          },
                          child: const Chip(
                              elevation: 2,
                              backgroundColor: primaryColor,
                              label: CustomText(
                                text: "All Specializations",
                                color: kwhite,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(left: ScreenSize.width * 0.07),
                        child: InkWell(
                          onTap: () {
                            homepageCtrl.setSpecialization(snapshot
                                .data.docs[index - 1]
                                .get("specialization"));
                          },
                          child: Chip(
                              elevation: 2,
                              backgroundColor: primaryColor,
                              label: CustomText(
                                text: snapshot.data.docs[index - 1]
                                    .get("specialization"),
                                color: kwhite,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      );
                    }
                  },
                );
              }
              return const CustomText(text: "Loading");
            },
          ),
        );
      },
    );
  }
}