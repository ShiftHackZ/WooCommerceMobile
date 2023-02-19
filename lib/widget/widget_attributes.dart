import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/model/attribute.dart';

class AttributesWidget extends StatelessWidget {
  final List<ProductAttribute> attrs;

  AttributesWidget(this.attrs);

  @override
  Widget build(BuildContext context) => Table(
        border: TableBorder(
          horizontalInside: BorderSide(
            width: 1,
            color: WooAppTheme.colorCommonBackground,
            style: BorderStyle.solid,
          ),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _buildRows(),
      );

  List<TableRow> _buildRows() {
    int index = 0;
    List<TableRow> result = [];
    for (var attr in attrs) {
      result.add(_buildRow(attr, (index % 2) == 0));
      index++;
    }
    return result;
  }

  TableRow _buildRow(ProductAttribute attribute, bool isEven) => TableRow(
        decoration: BoxDecoration(
          color: isEven
              ? WooAppTheme.colorCommonBackground
              : WooAppTheme.colorCommonSectionBackground.withOpacity(0.4),
        ),
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(2.0),
              width: 50.0,
              child: Text(
                attribute.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 3.9,
                  color: WooAppTheme.colorSecondaryForeground,
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Container(
              margin: EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              width: 50.0,
              child: Text(
                attribute.options.join(', '),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 4.4,
                  fontWeight: FontWeight.w600,
                  color: WooAppTheme.colorCommonText,
                ),
              ),
            ),
          ),
        ],
      );
}
