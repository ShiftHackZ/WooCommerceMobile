import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';

class BottomSheetBuilder extends StatelessWidget {
  final Widget content;

  BottomSheetBuilder(this.content);

  @override
  Widget build(BuildContext context) => Container(
    decoration: new BoxDecoration(
      color: Colors.white,
      borderRadius: new BorderRadius.only(
        topLeft: const Radius.circular(25.0),
        topRight: const Radius.circular(25.0),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Color(0x25000000),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              width: 150,
              height: 16,
            ),
          ),
          content
        ],
      ),
    ),
  );
}

class BottomSheetHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: WooAppTheme.colorCommonSectionBackground,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      width: 150,
      height: 16,
    ),
  );
}
