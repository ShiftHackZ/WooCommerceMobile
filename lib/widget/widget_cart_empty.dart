import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wooapp/config/theme.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback shoppingCallback;

  EmptyCartWidget(this.shoppingCallback);

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 300,
                child: Lottie.asset('assets/cart_empty.json'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'cart_empty_title',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: WooAppTheme.colorCommonText,
              ),
            ).tr(),
            SizedBox(height: 6),
            Text(
              'cart_empty_subtitle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: WooAppTheme.colorCommonText,
              ),
            ).tr(),
            SizedBox(height: 30),
            _buttonShopping(),
          ],
        ),
      );

  Widget _buttonShopping() => ElevatedButton(
        onPressed: shoppingCallback,
        child: Container(
          width: 200,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.basketShopping,
                color: WooAppTheme.colorSecondaryForeground,
              ),
              SizedBox(width: 14),
              Text(
                'cart_empty_action',
                style: TextStyle(
                  fontSize: 18,
                  color: WooAppTheme.colorSecondaryForeground,
                ),
              ).tr(),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            WooAppTheme.colorSecondaryBackground,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(
                color: WooAppTheme.colorSecondaryBackground,
              ),
            ),
          ),
        ),
      );
}
