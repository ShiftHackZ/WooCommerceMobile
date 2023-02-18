import 'package:flutter/material.dart';

class CustomDotDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          _generate(context),
          maxLines: 1,
          style: TextStyle(color: Colors.grey),
        ),
      );

  String _generate(BuildContext context) {
    var out = '';
    var max = MediaQuery.of(context).size.width.toInt() / 5;
    for (int i = 0; i < max; i++) out += '.';
    return out;
  }
}
