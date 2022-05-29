import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/screen_size.dart';
import '../Provider/homepage_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageController>(
      builder: (context, homePageCtrl, child) {
        return Scaffold(
          //floatingActionButton: const CustomFloatingAction(),
         // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(ScreenSize.width * .05),
            height: ScreenSize.width * .155,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.width * .02),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  homePageCtrl.onBottomNavItemChange(index);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == homePageCtrl.currentIndex
                          ? ScreenSize.width * .32
                          : ScreenSize.width * .18,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == homePageCtrl.currentIndex
                            ? ScreenSize.width * .12
                            : 0,
                        width: index == homePageCtrl.currentIndex
                            ? ScreenSize.width * .32
                            : 0,
                        decoration: BoxDecoration(
                          color: index == homePageCtrl.currentIndex
                              ? Colors.blueAccent.withOpacity(.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == homePageCtrl.currentIndex
                          ? ScreenSize.width * .31
                          : ScreenSize.width * .18,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == homePageCtrl.currentIndex
                                    ? ScreenSize.width * .13
                                    : 0,
                              ),
                              AnimatedOpacity(
                                opacity:
                                    index == homePageCtrl.currentIndex ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Text(
                                  index == homePageCtrl.currentIndex
                                      ? homePageCtrl.listOfStrings[index]
                                      : '',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == homePageCtrl.currentIndex
                                    ? ScreenSize.width * .03
                                    : 20,
                              ),
                              Icon(
                                homePageCtrl.listOfIcons[index],
                                size: ScreenSize.width * .076,
                                color: index == homePageCtrl.currentIndex
                                    ? Colors.blueAccent
                                    : Colors.black26,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: homePageCtrl.listOfScreens[homePageCtrl.currentIndex],
        );
      },
    );
  }
}


