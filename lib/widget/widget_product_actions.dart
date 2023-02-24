import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/datasource/wish_list_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/auth/login.dart';
import 'package:wooapp/screens/reviews/reviews.dart';
import 'package:wooapp/widget/widget_product_stock.dart';

class ProductActionsWidget extends StatefulWidget {
  static const double iconRadius = 20;
  static const double faRadius = 18;

  final Product product;

  final AppDb _db = locator<AppDb>();
  final WishListDataSource _ds = locator<WishListDataSource>();
  final Function() changeCallback;
  final bool displayWish;

  ProductActionsWidget({
    required this.product,
    required this.changeCallback,
    this.displayWish = false,
  });

  @override
  State<StatefulWidget> createState() => _ProductActionsWidgetState();
}

class _ProductActionsWidgetState extends State<ProductActionsWidget> {
  bool _hasAuth = false;
  bool _wishListPresent = false;
  bool _wishListOperationExecution = false;

  @override
  void initState() {
    widget._db
        .isAuthenticated()
        .then((hasAuth) => setState(() => _hasAuth = hasAuth))
        .then((_) => _executeWishFeatureInitialization());

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ProductStockWidget(widget.product),
          Spacer(),
          if (WooAppConfig.featureWishList && widget.displayWish) _buildIcon(
            FaIcon(
              _wishListPresent
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              color: WooAppTheme.colorSecondaryForeground,
            ),
            () {
              if (_hasAuth) {
                _executeWishFeatureOperation();
                return;
              }
              Navigator
                  .push(context, MaterialPageRoute(builder: (_) => LoginScreen()))
                  .then((value) {
                if (value == true) {
                  setState(() {
                    _hasAuth = true;
                  });
                  Timer(
                    Duration(milliseconds: 200),
                    () => _executeWishFeatureOperation(),
                  );
                }
              });
            },
          ),
          SizedBox(width: 8),
          _buildIcon(
            FaIcon(
              FontAwesomeIcons.comment,
              color: WooAppTheme.colorSecondaryForeground,
            ),
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReviewsScreen(widget.product.id),
              ),
            ),
          ),
          SizedBox(width: 8),
          _buildIcon(
            FaIcon(
              FontAwesomeIcons.share,
              color: WooAppTheme.colorSecondaryForeground,
            ),
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
    Color backgroundColor = WooAppTheme.colorSecondaryBackground,
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

  void _executeWishFeatureInitialization() {
    if (widget.displayWish) {
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
    }
  }



  void _executeWishFeatureOperation() {
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
  }
}
