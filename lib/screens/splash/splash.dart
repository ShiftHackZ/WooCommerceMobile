import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/datasource/category_attribute_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  final CategoryAttributeDateSource _ds =
      locator<CategoryAttributeDateSource>();
  final AppDb _db = locator<AppDb>();

  String _status = '';

  startTimer() async {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  Future navigationPage() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    preFetch();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: WooAppTheme.colorCommonBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Lottie.asset('assets/splash.json'),
              SizedBox(height: 20),
              Text(
                'app_name',
                style: TextStyle(
                  fontSize: 32.0,
                  color: WooAppTheme.colorCommonText,
                  fontWeight: FontWeight.w300,
                ),
              ).tr(),
              Spacer(),
              Text(
                _status,
                style: TextStyle(
                  color: WooAppTheme.colorSecondaryForeground,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );

  void preFetch() async {
    try {
      setState(() {
        _status = tr('splash_status_communicating');
      });
      var attrs = await _ds.getAttributes();
      setState(() {
        _status = tr('splash_status_cache');
      });
      for (var attr in attrs) {
        var terms = await _ds.getTerms(attr.id);
        await _db.saveFilter(attr, terms);
      }
      setState(() {
        _status = tr('splash_status_run');
      });
    } catch (e) {
      setState(() {
        _status = '';
      });
    } finally {
      startTimer();
    }
  }
}
