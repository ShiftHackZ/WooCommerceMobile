import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/screens/auth/login.dart';

class NoAuthScreen extends StatelessWidget {
  final String title;
  final VoidCallback onRefresh;
  final AppBar? appBar;

  NoAuthScreen({
    required this.title,
    required this.onRefresh,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        backgroundColor: WooAppTheme.colorCommonBackground,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Lottie.asset(
                    'assets/animations/noauth.json',
                    repeat: false,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'no_auth_hint',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: WooAppTheme.colorCommonText,
                  ),
                ).tr(),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()))
                        .then((value) {
                      onRefresh();
                      print('back, context = $context');
                    });
                  },
                  child: Container(
                    width: 90,
                    alignment: Alignment.center,
                    child: Text(
                      'sign_in_no_auth',
                      style: TextStyle(
                        fontSize: 16,
                        color: WooAppTheme.colorPrimaryForeground,
                      ),
                    ).tr(),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      WooAppTheme.colorPrimaryBackground,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0),
                        side: BorderSide(
                          color: WooAppTheme.colorPrimaryBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
