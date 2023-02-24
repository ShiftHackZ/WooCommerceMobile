import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class WooErrorStateWidget extends StatelessWidget {
  final VoidCallback onRetry;

  WooErrorStateWidget(this.onRetry);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 180,
                height: 180,
                child: Lottie.asset(
                  'assets/animations/error_retry.json',
                  repeat: false,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'error_state_oops',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ).tr(),
            SizedBox(height: 20),
            Text(
              'error_state_title',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ).tr(),
            SizedBox(height: 6),
            Text(
              'error_state_subtitle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ).tr(),
            SizedBox(height: 30),
            _buttonRetry(),
          ],
        ),
      );

  Widget _buttonRetry() => ElevatedButton(
        onPressed: onRetry,
        child: Container(
            width: 200,
            height: 40,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.redoAlt, color: Color(0xFF393939)),
                SizedBox(width: 14),
                Text(
                  'error_state_retry',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF393939),
                  ),
                ).tr(),
              ],
            )),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFDADADA)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(
                color: Color(0xFFDADADA),
              ),
            ),
          ),
        ),
      );
}
