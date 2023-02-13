import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sort {
  Widget icon;
  String title;
  String order;
  String orderBy;

  Sort(this.icon, this.title, this.order, this.orderBy);

  String query() => 'order=$order&orderby=$orderBy';

  Sort.byDefault()
    : icon = FaIcon(FontAwesomeIcons.calendarPlus),
      title = tr('sort_date_desc'),
      order = 'desc',
      orderBy = 'date';

  @override
  String toString() => query();
}