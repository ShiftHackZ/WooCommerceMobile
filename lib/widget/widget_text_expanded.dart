import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int length;
  final TextStyle style;

  ExpandableText({required this.text, required this.length, required this.style});

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  _ExpandableTextState();

  @override
  void initState() {
    super.initState();
    if (widget.text.length > widget.length) {
      firstHalf = widget.text.substring(0, widget.length);
      secondHalf = widget.text.substring(widget.length, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        child: secondHalf.isEmpty
            ? Text(firstHalf, style: widget.style)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: widget.style
                  ),
                  Container(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xD000000)),
                      ),
                      onPressed: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            flag
                                ? FontAwesomeIcons.arrowDown
                                : FontAwesomeIcons.arrowUp,
                            color: WooAppTheme.colorPrimaryBackground,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            flag ? 'exp_show_more' : 'exp_show_less',
                            style: TextStyle(
                              color: WooAppTheme.colorPrimaryBackground,
                            ),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
}
