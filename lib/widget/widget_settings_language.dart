import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Lang {
  String code;
  String title;

  Lang(this.code, this.title);
}

class LanguageWidget extends StatefulWidget {
  final Locale locale;
  final ValueSetter<Lang> callback;

  LanguageWidget(this.locale, this.callback);

  @override
  State<StatefulWidget> createState() => _LanguageWidgetState();

}

class _LanguageWidgetState extends State<LanguageWidget> {
  final List<Lang> _languages = [
    Lang('en', 'English'),
    Lang('uk', 'Українська'),
    Lang('ru', 'Русский'),
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(bottom: 8),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: _languages.length,
      itemBuilder: (context, index) => _langItem(_languages[index]),
    ),
  );

  Widget _langItem(Lang lang) => GestureDetector(
    onTap: () {
      widget.callback(lang);
      Navigator.of(context).pop();
    },
    child: Container(
      margin: EdgeInsets.only(top: 8, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Color(0x25636363),
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
              // height: 20,
              margin: EdgeInsets.only(left:0, right: 4),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FaIcon(FontAwesomeIcons.language),
              ),
            ),
            Text(
              '${lang.title}',
              style: TextStyle(
                  fontSize: widget.locale.languageCode.contains(lang.code) ? 18 : 17,
                  fontWeight: widget.locale.languageCode.contains(lang.code) ? FontWeight.w800 : FontWeight.w400
              ),
            ),
            Spacer(),
            if (widget.locale.languageCode.contains(lang.code)) Icon(Icons.check),
          ],
        ),
      ),
    ),
  );
}
