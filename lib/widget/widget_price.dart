import 'package:flutter/widgets.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/model/product.dart';

class PriceWidget extends StatelessWidget {

  final String price;
  final String salePrice;

  PriceWidget(this.price, this.salePrice);

  PriceWidget.withProduct(Product product)
      : price = product.regularPrice == '' ? product.price : product.regularPrice,
        salePrice = product.salePrice;

  @override
  Widget build(BuildContext context) {
    if (salePrice == '') {
      return Text(
        '$price${WooAppConfig.currency}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: WooAppTheme.colorPrice,
        ),
      );
    } else {
      return Row(
        children: [
          Text(
            '$price',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 13,
              color: WooAppTheme.colorPriceSale,
              fontWeight: FontWeight.w800
            ),
          ),
          Text(
            ' $salePrice${WooAppConfig.currency}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: WooAppTheme.colorPrice,
            ),
          ),
        ],
      );
    }
  }
}
