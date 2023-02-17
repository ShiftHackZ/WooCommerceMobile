import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/model/product.dart';

class ProductStockWidget extends StatelessWidget {
  static const String inStock = 'instock';
  static const String outOfStock = 'outofstock';
  static const String backOrder = 'onbackorder';

  final Product product;

  ProductStockWidget(this.product);

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    color: _bindCardColor(),
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          FaIcon(_bindIcon(), size: 14, color: _bindTextColor()),
          SizedBox(width: 4),
          Text(
            _bindStatus(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _bindTextColor(),
            ),
          ),
        ],
      )
    ),
  );

  IconData _bindIcon() {
    switch (product.stockStatus) {
      case inStock:
        return FontAwesomeIcons.check;
      case outOfStock:
        return FontAwesomeIcons.xmark;
      case backOrder:
        return FontAwesomeIcons.headset;
      default:
        return FontAwesomeIcons.check;
    }
  }

  Color _bindTextColor() {
    switch (product.stockStatus) {
      case inStock:
        return WooAppTheme.colorProductStatusBgInStock;
      case outOfStock:
        return WooAppTheme.colorProductStatusBgOutOfStock;
      case backOrder:
        return WooAppTheme.colorProductStatusBgBackOrder;
      default:
        return WooAppTheme.colorProductStatusBgDefault;
    }
  }

  Color _bindCardColor() {
    switch (product.stockStatus) {
      case inStock:
        return WooAppTheme.colorProductStatusTextInStock;
      case outOfStock:
        return WooAppTheme.colorProductStatusTextOutOfStock;
      case backOrder:
        return WooAppTheme.colorProductStatusTextBackOrder;
      default:
        return WooAppTheme.colorProductStatusTextDefault;
    }
  }

  String _bindStatus() {
    switch (product.stockStatus) {
      case inStock:
        if (product.stockCount != -1) {
          return '${product.stockCount} ${tr('in_stock').toLowerCase()}';
        } else {
          return tr('in_stock');
        }
      case outOfStock:
        return tr('out_of_stock');
      case backOrder:
        return tr('back_order');
      default:
        return tr('out_of_stock');
    }
  }
}
