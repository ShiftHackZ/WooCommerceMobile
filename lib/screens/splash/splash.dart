import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/datasource/category_attribute_data_source.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/screens/home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  final CategoryAttributeDateSource _ds = locator<CategoryAttributeDateSource>();
  final AppDb _db = locator<AppDb>();

  startTimer() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  Future navigationPage() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    _ds.getAttributes().then((attrs) {
      for (var attr in attrs) {
        _ds.getTerms(attr.id).then((terms) {
          _db.saveFilter(attr, terms);
        });
      }
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              'app_name',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ).tr(),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1,
            )
          ],
        ),
      ),
    );
  }
}
