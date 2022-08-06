import 'package:flutter/cupertino.dart';

class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;
  const Skeleton(
      {Key? key,
      required this.color,
      required this.height,
      required this.width,
      required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
    );
  }
}
