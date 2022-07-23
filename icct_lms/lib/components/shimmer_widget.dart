import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final ShapeBorder shapeBorder;
  const ShimmerWidget.rectangular(
      {Key? key, required this.height, this.width = double.infinity})
      : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular(
      {Key? key,
      required this.height,
      this.width = double.infinity,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(color: Colors.grey, shape: shapeBorder),
      ),
    );
  }
}
