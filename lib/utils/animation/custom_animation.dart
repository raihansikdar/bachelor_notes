import 'package:flutter/material.dart';

class CustomAnimation extends StatelessWidget {
  const CustomAnimation({
    super.key,
    required this.duration,
    required this.opacity,
    required this.child,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  final int duration;
  final Widget child;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double opacity;
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration:  Duration(milliseconds: duration),
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: AnimatedOpacity(
        duration:  Duration(milliseconds: duration),
        opacity: opacity,
        child: child,
      ),
    );
  }
}