import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';

class WooSection extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback action;
  final Color iconBackground;
  final EdgeInsetsGeometry padding;
  final Widget? endWidget;

  WooSection({
    required this.icon,
    required this.text,
    required this.action,
    this.iconBackground = Colors.transparent,
    this.padding = const EdgeInsets.only(left: 8, right: 8),
    this.endWidget,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      clipBehavior: Clip.hardEdge,
      color: WooAppTheme.colorCommonSectionBackground,
      child: InkWell(
        onTap: action,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: iconBackground,
                  border: Border.all(
                    color: iconBackground,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                width: 34,
                height: 34,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(child: icon),
                ),
              ),
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  color: WooAppTheme.colorCommonSectionForeground,
                ),
              ),
              Spacer(),
              endWidget ?? Container(),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: WooAppTheme.colorCommonSectionForeground
                    .withOpacity(0.35),
              ),
              SizedBox(width: 6),
            ],
          ),
        ),
      ),
    ),
  );

}
