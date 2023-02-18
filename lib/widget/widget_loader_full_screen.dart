import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';

class WooFullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {},
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: WooAppTheme.colorCommonText.withOpacity(0.7),
      ),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: WooAppTheme.colorPrimaryForeground.withOpacity(0.4),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: CircularProgressIndicator(
            color: WooAppTheme.colorPrimaryBackground,
          ),
        ),
      ),
    ),
  );
}
