import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled/model/product.dart';

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
        return FontAwesomeIcons.times;
      case backOrder:
        return FontAwesomeIcons.headset;
      default:
        return FontAwesomeIcons.check;
    }
  }

  Color _bindTextColor() {
    switch (product.stockStatus) {
      case inStock:
        return Color(0xFFFFFFFF);
      case outOfStock:
        return Color(0xFFFFF3F3);
      case backOrder:
        return Color(0xFF5A4D0D);
      default:
        return Color(0xFFFFF3F3);
    }
  }

  Color _bindCardColor() {
    switch (product.stockStatus) {
      case inStock:
        return Colors.lightGreen;
      case outOfStock:
        return Colors.redAccent;
      case backOrder:
        return Colors.amberAccent;
      default:
        return Colors.redAccent;
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
