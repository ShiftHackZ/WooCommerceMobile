import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/screens/featured/featured_sort.dart';

enum SortingType {
  home, catalog
}

class SortingWidget extends StatefulWidget {
  final Sort initialSort;
  final SortingType type;
  final ValueSetter<Sort> callback;

  SortingWidget(this.initialSort, this.type, this.callback);

  @override
  State<StatefulWidget> createState() => _SortingWidgetState();

}

class _SortingWidgetState extends State<SortingWidget> {
  late List<Sort> _sorts;
  late Sort _currentSort;

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case SortingType.catalog:
        _sorts = [
          Sort(
            _faIcon(FontAwesomeIcons.sortAlphaDown),
            tr('sort_alphabet_asc'),
            'asc',
            'name',
          ),
          Sort(
            _faIcon(FontAwesomeIcons.sortAlphaDownAlt),
            tr('sort_alphabet_desc'),
            'desc',
            'name',
          ),
        ];
        break;
      default:
        _sorts = [
          Sort(
            _faIcon(FontAwesomeIcons.thumbsUp),
            tr('sort_popular_asc'),
            'asc',
            'popularity',
          ),
          Sort(
            _faIcon(FontAwesomeIcons.solidStar),
            tr('sort_rating_asc'),
            'asc',
            'rating',
          ),

          Sort.byDefault(),
          Sort(
            _faIcon(FontAwesomeIcons.calendarMinus),
            tr('sort_date_asc'),
            'asc',
            'date',
          ),

          Sort(
            _faIcon(FontAwesomeIcons.donate),
            tr('sort_price_asc'),
            'asc',
            'price',
          ),
          Sort(
            _faIcon(FontAwesomeIcons.moneyCheckAlt),
            tr('sort_price_desc'),
            'desc',
            'price',
          ),

          Sort(
            _faIcon(FontAwesomeIcons.sortAlphaDown),
            tr('sort_alphabet_asc'),
            'asc',
            'title',
          ),
          Sort(
            _faIcon(FontAwesomeIcons.sortAlphaDownAlt),
            tr('sort_alphabet_desc'),
            'desc',
            'title',
          ),

          // Sort(FaIcon(FontAwesomeIcons.star), tr('sort_rating_desc'), 'desc', 'rating',),
          // Sort(FaIcon(FontAwesomeIcons.thumbsDown), tr('sort_popular_desc'), 'desc', 'popularity',),
        ];
        break;
    }
    _currentSort = widget.initialSort;
  }

  Widget _faIcon(IconData icon) => FaIcon(
        icon,
        color: WooAppTheme.colorCommonSectionForeground,
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(bottom: 8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _sorts.length,
          itemBuilder: (context, index) => _sortItem(
            _sorts[index],
            _currentSort.toString() == _sorts[index].toString(),
          ),
        ),
      );

  Widget _sortItem(Sort sort, bool selected) => GestureDetector(
        onTap: () {
          setState(() {
            _currentSort = sort;
          });
          widget.callback(sort);
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
                  // height: 20,
                  margin: EdgeInsets.only(left: 0, right: 4),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: sort.icon,
                  ),
                ),
                Text(
                  '${sort.title}',
                  style: TextStyle(
                    fontSize: selected ? 18 : 17,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w400,
                    color: WooAppTheme.colorCommonSectionForeground,
                  ),
                ),
                Spacer(),
                if (selected) Icon(
                  Icons.check,
                  color: WooAppTheme.colorCommonSectionForeground,
                ),
              ],
            ),
          ),
        ),
      );
}
