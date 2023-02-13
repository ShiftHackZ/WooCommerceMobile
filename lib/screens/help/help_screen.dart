import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('help').tr(),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            _profileSection(
                FaIcon(FontAwesomeIcons.headset),
                tr('support'),
                () {}
            ),
            _profileSection(
                FaIcon(FontAwesomeIcons.question),
                tr('faq'),
                () {}
            ),
            SizedBox(height: 8),
            _profileSection(
                FaIcon(FontAwesomeIcons.book),
                tr('privacy_policy'),
                () {}
            ),
            _profileSection(
                FaIcon(FontAwesomeIcons.list),
                tr('terms_of_use'),
                () {}
            ),
            _profileSection(
                FaIcon(FontAwesomeIcons.infoCircle),
                tr('about_us'),
                () {}
            ),
            SizedBox(height: 8),
            _profileSection(
                FaIcon(FontAwesomeIcons.star),
                tr('rate_app'),
                () {}
            ),
          ],
        ),
      ),
    ),
  );

  Widget _profileSection(Widget icon, String text, VoidCallback action, {Color iconBackground = Colors.transparent}) => Padding(
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
                  border: Border.all(
                      color: iconBackground
                  ),
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
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    ),
  );
}