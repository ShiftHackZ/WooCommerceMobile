import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/reviews/reviews.dart';
import 'package:wooapp/widget/widget_product_stock.dart';

class ProductActionsWidget extends StatefulWidget {
  static const double iconRadius = 20;
  static const double faRadius = 18;
  final Product product;

  ProductActionsWidget(this.product);

  @override
  State<StatefulWidget> createState() => _ProductActionsWidgetState();
}

class _ProductActionsWidgetState extends State<ProductActionsWidget> {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      ProductStockWidget(widget.product),
      Spacer(),
      _buildIcon(
          FaIcon(FontAwesomeIcons.heart, color: Colors.white),
          () { }
      ),
      SizedBox(width: 8),
      _buildIcon(
          FaIcon(FontAwesomeIcons.comment, color: Colors.white),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ReviewsScreen(widget.product.id)))
      ),
      SizedBox(width: 8),
      _buildIcon(
          FaIcon(FontAwesomeIcons.share, color: Colors.white),
          () => Share.share(
              'Check out: ${widget.product.name}\n${widget.product.permalink}',
              subject: 'Share ${widget.product.name}'
          ),
      ),
    ],
  );

  Widget _buildIcon(
      Widget icon,
      VoidCallback action, {
        Color backgroundColor = Colors.grey,
  }) => CircleAvatar(
    backgroundColor: backgroundColor,
    radius: ProductActionsWidget.iconRadius,
    child: GestureDetector(
      onTap: action,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(ProductActionsWidget.iconRadius)),
        child: icon,
      ),
    ),
  );
}
