import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Lottie.asset('assets/noauth.json', repeat: false)
            ),
            SizedBox(height: 32),
            Text(
              'no_auth_hint',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ).tr(),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator
                    .push(context, MaterialPageRoute(builder: (_) => LoginScreen()))
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
                    color: Colors.white,
                  ),
                ).tr(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF62A1E2)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0),
                      side: BorderSide(color: Colors.blue)
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