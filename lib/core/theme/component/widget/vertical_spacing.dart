import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const VerticalSpacing(this.height);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
