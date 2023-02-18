import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/datasource/cart_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/auth/login.dart';
import 'package:wooapp/screens/orders/create/create_order_screen.dart';
import 'package:wooapp/widget/widget_product_stock.dart';
import 'package:wooapp/widget/widget_product_variations.dart';
import 'package:wooapp/widget/widget_dialog.dart';

class AddToCartBottomBar extends StatefulWidget {
  final CartDataSource _ds = locator<CartDataSource>();
  final AppDb _db = locator<AppDb>();
  final Product product;

  AddToCartBottomBar(this.product);

  @override
  State<StatefulWidget> createState() {
    if (!WooAppConfig.featureCart)
      return _AddToCartBottomBarEmptyState();
    switch (product.stockStatus) {
      case ProductStockWidget.inStock:
        return _AddToCartBottomBarState();
      default:
        return _AddToCartBottomBarEmptyState();
    }
  }
}

class _AddToCartBottomBarEmptyState extends State<AddToCartBottomBar> {
  @override
  Widget build(BuildContext context) => SizedBox.shrink();
}

class _AddToCartBottomBarState extends State<AddToCartBottomBar> {
  final TextEditingController _countController = TextEditingController();

  int getCount() => int.tryParse(_countController.text) ?? 1;

  bool _inCart = false;
  bool _hasAuth = false;

  @override
  void initState() {
    super.initState();
    _countController.text = '1';
    checkIfAdded();
  }

  void checkIfAdded() async {
    var inCart = await widget._db.isInCart(widget.product.id);
    var hasAuth = await widget._db.isAuthenticated();
    setState(() {
      _inCart = inCart;
      _hasAuth = hasAuth;
    });
  }

  @override
  Widget build(BuildContext context) =>
      Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8, right: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !_inCart
                  ? _buildQuantityControls()
                  : Text(
                    'cart_contain',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ).tr(),
              Spacer(),
              !_inCart
                  ? _buildAddButton()
                  : _buildViewCartButton()
            ],
          ),
        ),
      );

  Widget _buildQuantityControls() => Row(children: [
    InkWell(
      onTap: () {
        if (getCount() > 1) {
          _countController.text = (getCount() - 1).toString();
        }
        hideKeyboardForce(context);
      },
      child: CircleAvatar(
        backgroundColor: WooAppTheme.colorSecondaryBackground,
        radius: 22,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          child: FaIcon(
            FontAwesomeIcons.minus,
            color: WooAppTheme.colorSecondaryForeground,
          ),
        ),
      ),
    ),
    Container(
      width: 50,
      child: TextField(
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _countController,
        textAlign: TextAlign.center,
        cursorColor: Color(0x00FFFFFF),
        // onChanged: (value) {
        //   _count = int.tryParse(_countController.text) ?? 1;
        // },
        // cursorColor: Colors.blue,
        style: TextStyle(
          fontSize: 20,
          color: WooAppTheme.colorCommonText,
        ),
        decoration: _decorate(),
      ),
    ),
    InkWell(
      onTap: () {
        _countController.text = (getCount() + 1).toString();
        hideKeyboardForce(context);
      },
      child: CircleAvatar(
        backgroundColor: WooAppTheme.colorSecondaryBackground,
        radius: 22,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: WooAppTheme.colorSecondaryForeground,
          ),
        ),
      ),
    ),
  ]);

  Widget _buildViewCartButton() => ElevatedButton(
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateOrderScreen()));
    },
    child: Container(
        alignment: Alignment.center,
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.check,
              color: WooAppTheme.colorPrimaryForeground,
            ),
            SizedBox(width: 8),
            Text(
              'cart_checkout',
              style: TextStyle(
                fontSize: 18,
                color: WooAppTheme.colorPrimaryForeground,
              ),
            ).tr(),
          ],
        )
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        WooAppTheme.colorPrimaryBackground,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(
            color: WooAppTheme.colorPrimaryBackground,
          ),
        ),
      ),
    ),
  );

  Widget _buildAddButton() => ElevatedButton(
        onPressed: () {
          Function() executeAddToCart = () {
            if (widget.product.isVariable) {
              _processVariableProduct();
            } else {
              _processSimpleProduct();
            }
          };
          if (_hasAuth) {
            executeAddToCart();
            return;
          }
          Navigator
            .push(context, MaterialPageRoute(builder: (_) => LoginScreen()))
            .then((value) {
              if (value == true) {
                setState(() {
                  _hasAuth = true;
                });
                Timer(Duration(milliseconds: 200), () => executeAddToCart());
              }
            });
        },
        child: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.cartPlus,
                color: WooAppTheme.colorPrimaryForeground,
              ),
              SizedBox(width: 8),
              Text(
                'cart_add',
                style: TextStyle(
                  fontSize: 18,
                  color: WooAppTheme.colorPrimaryForeground,
                ),
              ).tr(),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            WooAppTheme.colorPrimaryBackground,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(
                color: WooAppTheme.colorPrimaryBackground,
              ),
            ),
          ),
        ),
      );

  InputDecoration _decorate() => InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      );

  void _processSimpleProduct() {
    widget._ds.addItem(widget.product.id, getCount()).then((response) {
      setState(() {
        _inCart = true;
      });
    });
  }

  void _processVariableProduct() {
    var key = GlobalKey<ProductVariationSelectionWidgetState>();
    showDialog(
      context: context,
      builder: (ctx) => WooDialog(
        type: WooDialogType.widget,
        title: 'Select product properties',
        content: ProductVariationSelectionWidget(
          key: key,
          product: widget.product,
        ),
        buttonPositiveText: 'Add',
        onPositiveButton: () {
          var variations = key.currentState?.getVariations();
          if (variations != null) {
            widget._ds.addVariableItem(
              widget.product.id,
              getCount(),
              variations,
            ).then((response) {
              setState(() {
                _inCart = true;
              });
            });
          }
        },
      ),
    );
  }
}
