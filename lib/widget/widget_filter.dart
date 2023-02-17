import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/screens/featured/featured_filter.dart';

class FeaturedFilterWidget extends StatefulWidget {
  final FeaturedFilter initialFilter;
  final ValueSetter<FeaturedFilter> callback;

  final priceRangeMin = 0.0;
  final priceRangeMax;

  FeaturedFilterWidget(this.initialFilter, this.callback, {this.priceRangeMax = 1000.0});

  @override
  State<StatefulWidget> createState() => _FeaturedFilterWidgetState();
}

class _FeaturedFilterWidgetState extends State<FeaturedFilterWidget> {
  late FeaturedFilter _filter;

  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _currentRangeValues = RangeValues(widget.priceRangeMin, widget.priceRangeMax);
    if (_filter.minPrice != -1) {
      _currentRangeValues = RangeValues(_filter.minPrice, _currentRangeValues.end);
    }
    if (_filter.maxPrice != -1) {
      _currentRangeValues = RangeValues(_currentRangeValues.start, _filter.maxPrice);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    child: Column(
      children: [
        _priceItem(),
        _stockItem(),
        _switchItem(
          tr('filter_on_sale'),
          _filter.onSale,
          (state) {
            setState(() {
              _filter = _filter
                ..resetLogic()
                ..onSale = state;
            });
          },
        ),
        _switchItem(
          tr('filter_featured'),
          _filter.featured,
          (state) {
            setState(() {
              _filter = _filter
                ..resetLogic()
                ..featured = state;
            });
          },
        ),

        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 26),
          child: Row(
            children: [
              Expanded(child: _buttonClear()),
              SizedBox(width: 8),
              Expanded(child: _buttonApply()),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _priceItem() => Container(
    margin: EdgeInsets.only(top: 8, right: 16, left: 16),
    decoration: BoxDecoration(
      color: WooAppTheme.colorCommonSectionBackground,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'filter_price',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ).tr(),
              Spacer(),
              Text(
                '${_currentRangeValues.start.round()}${WooAppConfig.currency}'
                ' — '
                '${_currentRangeValues.end.round()}${WooAppConfig.currency}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: widget.priceRangeMax,
            activeColor: WooAppTheme.colorPrimaryBackground,
            inactiveColor: WooAppTheme.colorPrimaryForeground,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (range) {
              setState(() {
                _currentRangeValues = range;
              });
            },
          ),
        ],
      ),
    ),
  );

  Widget _stockItem() => Container(
      margin: EdgeInsets.only(top: 8, right: 16, left: 16),
      decoration: BoxDecoration(
        color: WooAppTheme.colorCommonSectionBackground,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'filter_stock',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400
              ),
            ).tr(),
            Spacer(),
            _stockParentItem(
              tr('in_stock'),
              _filter.stockStatus == FeaturedFilter.stockAvailable,
              (value) {
                setState(() {
                  _filter = _filter
                    ..resetStock()
                    ..stockStatus = value ? FeaturedFilter.stockAvailable : '';
                });
              }
            ),
            SizedBox(width: 8),
            _stockParentItem(
              tr('back_order'),
              _filter.stockStatus == FeaturedFilter.stockBackOrder,
              (value) {
                setState(() {
                  _filter = _filter
                    ..resetStock()
                    ..stockStatus = value ? FeaturedFilter.stockBackOrder : '';
                });
              }
            )
          ],
        ),
      ),
  );

  Widget _stockParentItem(String title, bool selected, ValueSetter<bool> callback) => GestureDetector(
    onTap: () {
      callback(!selected);
    },
    child: Container(
      decoration: BoxDecoration(
        color: selected
            ? WooAppTheme.colorPrimaryBackground
            : Color(0x73636363),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: selected ? 16 : 15,
          fontWeight: selected
              ? FontWeight.w600
              : FontWeight.w400,
          color: selected
              ? WooAppTheme.colorPrimaryForeground
              : Color(0xFF232323),
        ),
      ),
    ),
  );

  Widget _switchItem(String title, bool selected, ValueSetter<bool> callback) => GestureDetector(
    onTap: () {
      callback(!selected);
    },
    child: Container(
      margin: EdgeInsets.only(top: 8, right: 16, left: 16),
      decoration: BoxDecoration(
        color: WooAppTheme.colorCommonSectionBackground,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400
              ),
            ),
            Spacer(),
            Switch(
              value: selected,
              onChanged: callback,
              activeColor: WooAppTheme.colorPrimaryBackground,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buttonClear() => ElevatedButton(
    onPressed: () {
      setState(() {
        _filter = _filter..clear();
      });
      widget.callback(_filter);
      Navigator.of(context).pop();
    },
    child: Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.times,
            color: WooAppTheme.colorSecondaryForeground,
          ),
          SizedBox(width: 8),
          Text(
            'filter_clear',
            style: TextStyle(
              fontSize: 18,
              color: WooAppTheme.colorSecondaryForeground,
            ),
          ).tr(),
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

  Widget _buttonApply() => ElevatedButton(
    onPressed: () {
      setState(() {
        if (_currentRangeValues.start != widget.priceRangeMin) {
          _filter = _filter..minPrice = _currentRangeValues.start.roundToDouble();
        } else {
          _filter = _filter..minPrice = -1;
        }
        if (_currentRangeValues.end != widget.priceRangeMax) {
          _filter = _filter..maxPrice = _currentRangeValues.end.roundToDouble();
        } else {
          _filter = _filter..maxPrice = -1;
        }
      });
      widget.callback(_filter);
      Navigator.of(context).pop();
    },
    child: Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.check,
            color: WooAppTheme.colorPrimaryForeground,
          ),
          SizedBox(width: 8),
          Text(
            'filter_apply',
            style: TextStyle(
              fontSize: 18,
              color: WooAppTheme.colorPrimaryForeground,
            ),
          ).tr(),
        ],
      ),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        WooAppTheme.colorPrimaryBackground,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(
            color: WooAppTheme.colorPrimaryBackground,
          ),
        ),
      ),
    ),
  );
}
