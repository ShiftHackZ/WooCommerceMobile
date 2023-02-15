import 'package:flutter/material.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/database/filter.dart';
import 'package:wooapp/database/filter_value.dart';
import 'package:wooapp/locator.dart';

class CategoryFilterItem extends StatelessWidget {
  final Filter filter;
  final VoidCallback onChanged;

  CategoryFilterItem(this.filter, this.onChanged);

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        _buildTerms(),
      ],
    ),
  );

  Widget _buildTerms() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var item in filter.values) CategoryFilterValue(filter, item, onChanged)
    ],
  );
}

class CategoryFilterValue extends StatefulWidget {
  final AppDb _db = locator<AppDb>();
  final Filter filter;
  final FilterValue value;
  final VoidCallback onChanged;
  // final bool isSelected;

  CategoryFilterValue(this.filter, this.value, this.onChanged);

  @override
  State<StatefulWidget> createState() => _CategoryFilterValueState();
}

class _CategoryFilterValueState extends State<CategoryFilterValue> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    widget._db.isActiveFilter(widget.filter.id, widget.value.id).then((active) {
      setState(() {
        _isSelected = active;
      });
    }).catchError((error) {
      print('$error');
      setState(() {
        _isSelected = false;
      });
    });
    print("[APPLIED_FILTER] initial state for [${widget.filter.slug}] with value [${widget.value.id}] = $_isSelected");
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Checkbox(
          value: _isSelected,
          onChanged: (value) {
            setState(() {
              _isSelected = value!;
              if (_isSelected) {
                print("[APPLIED_FILTER] >>> APPLYING filter [${widget.filter.slug}] with value [${widget.value.id}]");
                widget._db.applyFilter(widget.filter, widget.value);
              } else {
                print("[APPLIED_FILTER] <<< REMOVING filter [${widget.filter.slug}] with value [${widget.value.id}]");
                widget._db.removeFilter(widget.filter, widget.value);
              }
              widget.onChanged();
            });
          }
      ),
      Text(widget.value.name),
    ],
  );
}