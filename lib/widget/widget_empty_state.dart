import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wooapp/config/theme.dart';

enum WooEmptyStateAnimation {
  girlShakeBox,
  wishlist,
  review,
}

class WooEmptyStateAction {
  final String buttonLabel;
  final VoidCallback buttonClick;
  final IconData? icon;

  WooEmptyStateAction({
    required this.buttonLabel,
    required this.buttonClick,
    this.icon,
  });
}

class WooEmptyStateWidget extends StatelessWidget {
  final String keyTitle;
  final String keySubTitle;
  final WooEmptyStateAnimation animation;
  final WooEmptyStateAction? action;
  final MainAxisAlignment mainAxisAlignment;

  WooEmptyStateWidget({
    this.keyTitle = 'empty_state_title',
    this.keySubTitle = 'empty_state_subtitle',
    this.animation = WooEmptyStateAnimation.girlShakeBox,
    this.action,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Center(
              child: Container(
                child: Lottie.asset(
                  _bindAnimation(),
                  height: MediaQuery.of(context).size.height * 0.33,
                  repeat: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              keyTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ).tr(),
            SizedBox(height: 16),
            Text(
              keySubTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ).tr(),
            if (action != null) SizedBox(height: 30),
            if (action != null) _buttonAction(),
          ],
        ),
      );

  Widget _buttonAction() => ElevatedButton(
        onPressed: () {
          if (action != null) {
            action?.buttonClick();
          }
        },
        child: Container(
          width: 200,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (action?.icon != null) FaIcon(
                action?.icon ?? FontAwesomeIcons.basketShopping,
                color: WooAppTheme.colorSecondaryForeground,
              ),
              SizedBox(width: 14),
              Text(
                action?.buttonLabel ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: WooAppTheme.colorSecondaryForeground,
                ),
              ),
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

  String _bindAnimation() {
    switch (animation) {
      case WooEmptyStateAnimation.wishlist:
        return 'assets/animations/empty_state_wishlist.json';
      case WooEmptyStateAnimation.review:
        return 'assets/animations/empty_review.json';
      default:
        return 'assets/animations/empty_state.json';
    }
  }
}
