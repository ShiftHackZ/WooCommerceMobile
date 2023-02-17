import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/widget/widget_settings_language.dart';
import 'package:wooapp/widget/widget_woo_section.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          title: Text(
            'settings',
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
                SizedBox(height: 8),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.globe,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  endWidget: Text(
                    'lang',
                    style: TextStyle(
                      color: WooAppTheme.colorCommonSectionForeground,
                    ),
                  ).tr(),
                  text: tr('settings_language'),
                  action: () => showBottomOptions(
                    context,
                    LanguageWidget(
                      context.locale,
                      (lang) => context.setLocale(lang.locale),
                    ),
                  ),
                ),
                WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('settings_password'),
                  action: () {},
                ),
              ],
            ),
          ),
        ),
      );
}
