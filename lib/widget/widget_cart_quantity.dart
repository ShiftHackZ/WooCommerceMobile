import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/datasource/cart_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';

class CartQuantityWidget extends StatefulWidget {
  final CartDataSource _ds = locator<CartDataSource>();
  final String productCartKey;
  final int initialQuantity;
  final VoidCallback callback;

  CartQuantityWidget(this.productCartKey, this.initialQuantity, this.callback);

  @override
  State<StatefulWidget> createState() => _CartQuantityWidgetState();
}

class _CartQuantityWidgetState extends State<CartQuantityWidget> {

  static const double buttonSize = 16;

  final TextEditingController _countController = TextEditingController();

  int getCount() => int.tryParse(_countController.text) ?? 1;

  @override
  void initState() {
    super.initState();
    _countController.text = '${widget.initialQuantity}';
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          if (getCount() > 1) {
            _countController.text = (getCount() - 1).toString();
            _syncQuantity();
          }
          hideKeyboardForce(context);
        },
        child: CircleAvatar(
          backgroundColor: WooAppTheme.colorSecondaryBackground,
          radius: buttonSize,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(buttonSize)),
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
            // color: Colors.white
          ),
          decoration: _decorate(),
        ),
      ),
      InkWell(
        onTap: () {
          _countController.text = (getCount() + 1).toString();
          _syncQuantity();
          hideKeyboardForce(context);
        },
        child: CircleAvatar(
          backgroundColor: WooAppTheme.colorSecondaryBackground,
          radius: buttonSize,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(buttonSize)),
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: WooAppTheme.colorSecondaryForeground,
            ),
          ),
        ),
      ),
    ],
  );

  void _syncQuantity() {
    widget._ds.updateQuantity(widget.productCartKey, getCount()).then((_) {
      widget.callback();
    });
  }

  InputDecoration _decorate() => InputDecoration(
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
  );
}
