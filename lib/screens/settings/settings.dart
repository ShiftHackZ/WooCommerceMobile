import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/core/pop_controller.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/preferences/preferences_manager.dart';
import 'package:wooapp/widget/widget_settings_language.dart';
import 'package:wooapp/widget/widget_settings_list_style.dart';
import 'package:wooapp/widget/widget_woo_section.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _preferences = locator<PreferencesManager>();
  final _willPopController = WillPopController();

  bool _displayGrid = true;

  @override
  void initState() {
    _preferences
        .getGridDisplayEnabled()
        .then((value) => setState(() => _displayGrid = value));

    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: _buildSettings(),
        onWillPop: () {
          Navigator.pop(context, _willPopController.value);
          return Future(() => false);
        },
      );

  Widget _buildSettings() => Scaffold(
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
                  action: () => showWooBottomSheet(
                    context,
                    LanguageWidget(
                      context.locale,
                      (lang) {
                        _willPopController.value = true;
                        context.setLocale(lang.locale);
                      },
                    ),
                  ),
                ),
                WooSection(
                  icon: Icon(
                    Icons.list,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('settings_list_style'),
                  action: () => showWooBottomSheet(
                    context,
                    ListStyleWidget(
                      displayGrid: _displayGrid,
                      callback: (value) {
                        _willPopController.value = true;
                        _preferences.setGridDisplayEnabled(value);
                        setState(() => _displayGrid = value);
                      },
                    ),
                  ),
                  endWidget: Text(
                    _displayGrid
                        ? 'list_style_grid'
                        : 'list_style_default',
                    style: TextStyle(
                      color: WooAppTheme.colorCommonSectionForeground,
                    ),
                  ).tr(),
                ),
                /*WooSection(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                  text: tr('settings_password'),
                  action: () {},
                ),*/
              ],
            ),
          ),
        ),
      );
}
