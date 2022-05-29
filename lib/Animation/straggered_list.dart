
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomStaggeredList extends StatelessWidget {
  const CustomStaggeredList(
      {Key? key, required this.index, required this.child})
      : super(key: key);
  final int index;
  final dynamic child;
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: const Duration(milliseconds: 2500),
        curve: Curves.fastLinearToSlowEaseIn,
        verticalOffset: -250,
        child: ScaleAnimation(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.fastLinearToSlowEaseIn,
          child: child,
        ),
      ),
    );
  }
}
