import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/widget/widget_settings_language.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('settings').tr(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8),
                _section(
                  FaIcon(FontAwesomeIcons.globe),
                  Text('lang').tr(),
                  tr('settings_language'),
                  () => showBottomOptions(
                    context,
                    LanguageWidget(
                      context.locale,
                      (lang) => context.setLocale(lang.locale),
                    ),
                  ),
                ),
                _section(
                  FaIcon(FontAwesomeIcons.key),
                  SizedBox.shrink(),
                  tr('settings_password'),
                  () {},
                ),
              ],
            ),
          ),
        ),
      );

  Widget _section(
    Widget icon,
    Widget endChild,
    String text,
    VoidCallback action, {
    Color iconBackground = Colors.transparent,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          color: Colors.white70,
          child: InkWell(
            onTap: action,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: iconBackground,
                      border: Border.all(color: iconBackground),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    width: 34,
                    height: 34,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Center(child: icon),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(text, style: TextStyle(fontSize: 17)),
                  Spacer(),
                  endChild,
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
      );
}
