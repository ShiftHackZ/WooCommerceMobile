import 'package:flutter/widgets.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const StatefulWrapper({super.key, required this.onInit, required this.child});

  @override
  StatefulWrapperState createState() => StatefulWrapperState();
}

class StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    executeInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
  void executeInit() {
    widget.onInit();
  }
}
