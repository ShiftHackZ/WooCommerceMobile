import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/translations.dart';

class LanguageWidget extends StatefulWidget {
  final Locale locale;
  final ValueSetter<Language> callback;

  LanguageWidget(this.locale, this.callback);

  @override
  State<StatefulWidget> createState() => _LanguageWidgetState();

}

class _LanguageWidgetState extends State<LanguageWidget> {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(bottom: 8),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: Translations.languages.length,
      itemBuilder: (_, index) => _langItem(Translations.languages[index]),
    ),
  );

  Widget _langItem(Language lang) => GestureDetector(
    onTap: () {
      widget.callback(lang);
      Navigator.of(context).pop();
    },
    child: Container(
      margin: EdgeInsets.only(top: 8, right: 16, left: 16),
      decoration: BoxDecoration(
        color: WooAppTheme.colorCommonSectionBackground,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 6, right: 16, top: 12, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 50,
              margin: EdgeInsets.only(left:0, right: 4),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FaIcon(
                  FontAwesomeIcons.language,
                  color: WooAppTheme.colorCommonSectionForeground,
                ),
              ),
            ),
            Text(
              '${lang.title}',
              style: TextStyle(
                fontSize: widget.locale.languageCode.contains(lang.locale.languageCode) ? 18 : 17,
                fontWeight: widget.locale.languageCode.contains(lang.locale.languageCode) ? FontWeight.w800 : FontWeight.w400,
                color: WooAppTheme.colorCommonSectionForeground,
              ),
            ),
            Spacer(),
            if (widget.locale.languageCode.contains(lang.locale.languageCode))
              Icon(
                Icons.check,
                color: WooAppTheme.colorCommonSectionForeground,
              ),
          ],
        ),
      ),
    ),
  );
}
