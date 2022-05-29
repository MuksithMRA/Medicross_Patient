import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({Key? key, required this.enabled, required this.child, required this.w, required this.h})
      : super(key: key);
  final bool enabled;
  final Widget child;
  final double w;
  final double h;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: Shimmer.fromColors(
        enabled: enabled,
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: child,
      ),
    );
  }
}
