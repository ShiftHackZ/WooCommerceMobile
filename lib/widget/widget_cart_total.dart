import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/cart_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/cart_response.dart';
import 'package:wooapp/widget/widget_cart_quantity.dart';

class CartTotalItem extends StatefulWidget {
  final CartDataSource _ds = locator<CartDataSource>();
  final CartItem item;

  CartTotalItem(this.item);

  @override
  State<StatefulWidget> createState() => _CartTotalItemState(item.totals.total.toString());

}

class _CartTotalItemState extends State<CartTotalItem> {

  final String initialTotal;

  var isLoading = false;
  var total = '';

  _CartTotalItemState(this.initialTotal);

  @override
  void initState() {
    super.initState();
    total = initialTotal;
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Text(
      //   'Total: ',
      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      // ),
      !isLoading
          ? Text(
            '$total${WooAppConfig.currency}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: WooAppTheme.colorPrice,
            ),
          )
          : Container(
              width: 100,
              height: 14,
              child: Shimmer(
                duration: Duration(seconds: 1),
                enabled: true,
                direction: ShimmerDirection.fromLTRB(),
                child: Container(color: Colors.white70)
              ),
          ),
      Spacer(),
      CartQuantityWidget(widget.item.itemKey, widget.item.quantity.value, () {
        updatePrice();
      }),
    ],
  );

  void updatePrice() {
    setState(() {
      isLoading = true;
    });
    widget._ds.getItem(widget.item.itemKey).then((item) {
      setState(() {
        isLoading = false;
        total = item.totals.total.toString();
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        total = initialTotal;
      });
    });
  }
}
