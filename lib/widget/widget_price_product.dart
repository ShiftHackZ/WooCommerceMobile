import 'package:flutter/widgets.dart';
import 'package:wooapp/constants/colors.dart';
import 'package:wooapp/constants/config.dart';
import 'package:wooapp/model/product.dart';

class ProductPriceWidget extends StatelessWidget {

  final String price;
  final String salePrice;

  ProductPriceWidget(this.price, this.salePrice);

  ProductPriceWidget.withProduct(Product product)
      : price = product.regularPrice == '' ? product.price : product.regularPrice,
        salePrice = product.salePrice;

  @override
  Widget build(BuildContext context) {
    if (salePrice == '') {
      return Text(
        '$price${AppConfig.currency}',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      );
    } else {
      return Row(
        children: [
          Text(
            '$price${AppConfig.currency}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 16,
                color: AppColor.priceSale,
                fontWeight: FontWeight.w800
            ),
          ),
          Text(
            ' $salePrice${AppConfig.currency}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ],
      );
    }
  }
}
