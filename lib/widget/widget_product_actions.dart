import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:wooapp/datasource/wish_list_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/reviews/reviews.dart';
import 'package:wooapp/widget/widget_product_stock.dart';

class ProductActionsWidget extends StatefulWidget {
  static const double iconRadius = 20;
  static const double faRadius = 18;

  final Product product;

  final WishListDataSource _ds = locator<WishListDataSource>();
  final Function() changeCallback;

  ProductActionsWidget({
    required this.product,
    required this.changeCallback,
  });

  @override
  State<StatefulWidget> createState() => _ProductActionsWidgetState();
}

class _ProductActionsWidgetState extends State<ProductActionsWidget> {
  bool _wishListPresent = false;
  bool _wishListOperationExecution = false;

  @override
  void initState() {
    setState(() {
      _wishListOperationExecution = true;
    });
    widget._ds
        .isInWishListByProductId(widget.product.id)
        .then((value) {
      setState(() {
        _wishListOperationExecution = false;
        _wishListPresent = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _wishListOperationExecution = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ProductStockWidget(widget.product),
          Spacer(),
          _buildIcon(
            FaIcon(
              _wishListPresent
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              color: Colors.white,
            ),
            () {
              if (_wishListOperationExecution) return;
              var initialValue = _wishListPresent;
              widget.changeCallback();
              setState(() {
                _wishListOperationExecution = true;
                _wishListPresent = !_wishListPresent;
              });
              if (!initialValue) {
                widget._ds.addProduct(widget.product.id).then((_) {
                  _wishListOperationExecution = false;
                }).onError((error, stackTrace) {
                  _wishListOperationExecution = false;
                });
              } else {
                widget._ds.removeProductByProductId(widget.product.id).then((_) {
                  _wishListOperationExecution = false;
                }).onError((error, stackTrace) {
                  _wishListOperationExecution = false;
                });
              }
            },
          ),
          SizedBox(width: 8),
          _buildIcon(
            FaIcon(FontAwesomeIcons.comment, color: Colors.white),
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReviewsScreen(widget.product.id),
              ),
            ),
          ),
          SizedBox(width: 8),
          _buildIcon(
            FaIcon(FontAwesomeIcons.share, color: Colors.white),
            () => Share.share(
              'Check out: ${widget.product.name}\n${widget.product.permalink}',
              subject: 'Share ${widget.product.name}',
            ),
          ),
        ],
      );

  Widget _buildIcon(
    Widget icon,
    VoidCallback action, {
    Color backgroundColor = Colors.grey,
  }) =>
      GestureDetector(
        onTap: action,
        child: Container(
          padding: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(ProductActionsWidget.iconRadius),
            ),
          ),
          child: icon,
        ),
      );
}
