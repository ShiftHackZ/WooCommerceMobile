import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
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
  final GlobalKey<CartQuantityWidgetState> _keyQuantity = GlobalKey();
  final String _initialTotal;

  var _isLoading = false;
  var _total = '';

  _CartTotalItemState(this._initialTotal);

  @override
  void initState() {
    setState(() {
      _total = _initialTotal;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Text(
      //   'Total: ',
      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      // ),
      !_isLoading
          ? Text(
            '$_total${WooAppConfig.currency}',
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
                color: WooAppTheme.colorShimmerForeground,
                child: Container(
                  color: WooAppTheme.colorShimmerBackground,
                ),
              ),
          ),
      Spacer(),
      CartQuantityWidget(
        key: _keyQuantity,
        productCartKey: widget.item.itemKey,
        initialQuantity:  widget.item.quantity.value,
        callback: () => updatePrice(),
      ),
    ],
  );

  void updatePrice() {
    setState(() {
      _isLoading = true;
    });
    widget._ds.getItem(widget.item.itemKey).then((item) {
      setState(() {
        _isLoading = false;
        _total = item.totals.total.toString();
        _keyQuantity.currentState?.onLoadingFinished();
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _total = _initialTotal;
        _keyQuantity.currentState?.onLoadingFinished();
      });
    });
  }
}
