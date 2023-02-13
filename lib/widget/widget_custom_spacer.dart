import 'package:flutter/material.dart';

class PointPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final point = TextPainter(
        text: TextSpan(text: ".", style: TextStyle(color: Colors.grey)),
        textDirection: TextDirection.ltr);
    point.layout(maxWidth: size.width);

    for (double i = 0; i < size.width; i += point.width) {
      point.paint(canvas, Offset(i, -6.0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DotSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: CustomPaint(painter: PointPainter()),
    ),
  );
}
