import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.borderRadius: 25.0,
    this.height: 50.0,
    this.width,
    this.color: Colors.white,
    this.onPressed,
    this.opacity: 1.0,
  }) : assert(borderRadius != null);
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    Color c1 = const Color(0xFF4776e6);
    Color c2 = const Color(0xFF8e54e9);
    return Opacity(
      opacity: opacity,
      child: SizedBox(
        height: height,
        width: width,
        child: RaisedButton(
          child: Container(
              child: child),
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
