import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SectionWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback action;

  SectionWidget(this.iconData, this.text, this.action);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: action,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(iconData),
          SizedBox(width: 10.0),
          Text(text, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400)),
          Spacer(),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
}
