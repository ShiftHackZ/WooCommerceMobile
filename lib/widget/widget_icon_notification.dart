import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {

  final Widget icon;
  final bool showDot;

  NotificationIcon(this.icon, this.showDot);

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    child: Stack(
      children: [
        Icon(
          Icons.filter_alt_rounded,
          color: Colors.white,
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.topRight,
          // margin: EdgeInsets.only(top: 5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: showDot ? Color(0xffc32c37) : Color(0x00000000),
              // border: Border.all(color: Colors.white, width: 0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: Text(
                  '',//_counter.toString(),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
