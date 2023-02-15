import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/constants/config.dart';
import 'package:wooapp/model/product.dart';

class ProductInfoWidget extends StatelessWidget {
  final Product product;

  ProductInfoWidget(this.product);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Table(
      border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.black38, style: BorderStyle.solid)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildRows(),
    ),
  );

  List<TableRow> _buildRows() {
    List<TableRow> result = [];

    result.add(_buildRow(tr('product_property_id'), product.id.toString(), true));
    result.add(_buildRow(tr('product_property_name'), product.name, false));
    result.add(_buildRow(tr('product_property_price'), '${product.price}${AppConfig.currency}', true));
    result.add(_buildRow(tr('product_property_created'), product.dateCreated, false));
    result.add(_buildRow(tr('product_property_modified'), product.dateModified, true));
    result.add(_buildRow(tr('product_property_type'), product.type, false));
    result.add(_buildRow(tr('product_property_status'), product.status, true));
    result.add(_buildRow(tr('product_property_stock'), product.stockStatus, false));
    result.add(_buildRow(tr('product_property_sku'), product.sku.isNotEmpty ? product.sku : tr('product_property_undefined'), true));
    result.add(_buildRow(tr('product_property_rating'), product.rating.toString(), false));
    result.add(_buildRow(tr('product_property_images'), product.images.length.toString(), true));

    return result;
  }

  TableRow _buildRow(String key, String value, bool isEven) => TableRow(
    decoration: BoxDecoration(color: isEven ? Colors.white : Color(0xFFECECEC)),
    children: [
      FittedBox(
        fit: BoxFit.contain,
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(2.0),
          width: 50.0,
          child: Text(
            key,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 3.9
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
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 4.4,
                  fontWeight: FontWeight.w600
              )
          ),
        ),
      ),
    ],
  );
}
