import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int length;
  final TextStyle style;

  ExpandableText({required this.text, required this.length, required this.style});

  @override
  _ExpandableTextState createState() => new _ExpandableTextState(length, style);
}

class _ExpandableTextState extends State<ExpandableText> {
  final int collapsedLength;
  final TextStyle style;
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  _ExpandableTextState(this.collapsedLength, this.style);

  @override
  void initState() {
    super.initState();

    if (widget.text.length > collapsedLength) {
      firstHalf = widget.text.substring(0, collapsedLength);
      secondHalf = widget.text.substring(collapsedLength, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        child: secondHalf.isEmpty
            ? Text(firstHalf, style: style)
            : Column(
                children: <Widget>[
                  Text(
                    flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: style
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          flag ? 'exp_show_more' : 'exp_show_less',
                          style: TextStyle(color: Colors.blue),
                        ).tr(),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  ),
                ],
              ),
      );
}
