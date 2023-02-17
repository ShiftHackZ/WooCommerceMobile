import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/widget/widget_woo_section.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          title: Text(
            'help',
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ).tr(),
          backgroundColor: WooAppTheme.colorToolbarBackground,
        ),
        backgroundColor: WooAppTheme.colorCommonBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.headset,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('support'),
                  action: () {},
                ),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.question,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('faq'),
                  action: () {},
                ),
                SizedBox(height: 8),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.book,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('privacy_policy'),
                  action: () {},
                ),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.list,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('terms_of_use'),
                  action: () {},
                ),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.circleInfo,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('about_us'),
                  action: () {},
                ),
                SizedBox(height: 8),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.star,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('rate_app'),
                  action: () {},
                ),
              ],
            ),
          ),
        ),
      );
}
