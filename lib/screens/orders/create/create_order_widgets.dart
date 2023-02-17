import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/extensions/extensions_widget.dart';
import 'package:wooapp/model/cart_response.dart';
import 'package:wooapp/widget/widget_custom_spacer.dart';

class CreateOrderHeader extends StatelessWidget {
  final Widget icon;
  final String text;
  final Widget end;

  CreateOrderHeader(this.icon, this.text, {this.end = const Text('')});

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 18, right: 8, left: 8),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 4, right: 8),
                child: Container(
                  width: 40,
                  child: Center(child: icon),
                )),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: WooAppTheme.colorCreateOrderHeaderText,
              ),
            ),
            Spacer(),
            end,
          ],
        ),
      );
}

class CreateOrderSection extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;
  final VoidCallback action;

  CreateOrderSection(this.icon, this.label, this.value, this.action);

  @override
  Widget build(BuildContext context) => Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
          ),
          color: WooAppTheme.colorCardCreateOrderBackground,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: action,
            child: Row(
              children: [
                Container(
                  width: 40,
                  child: Center(child: icon),
                ),
                SizedBox(width: 8),
                Text(
                  '$label: ',
                  style: TextStyle(
                    fontSize: 15.8,
                    fontWeight: FontWeight.w400,
                    color: WooAppTheme.colorCardCreateOrderText,
                  ),
                ),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: WooAppTheme.colorCardCreateOrderText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class CreateOrderProduct extends StatelessWidget {
  final CartItem item;

  CreateOrderProduct(this.item);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
          ),
          color: WooAppTheme.colorCardCreateOrderBackground,
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              _buildItemImage(context, item.id, item.featuredImage),
              SizedBox(width: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width - 176,
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: WooAppTheme.colorCardCreateOrderText,
                  ),
                ),
              ),
              DotSpacer(),
              Text(
                '${item.quantity.value} x ',
                style: TextStyle(
                  color: WooAppTheme.colorCardCreateOrderText,
                ),
              ),
              Text(
                '${item.price}${WooAppConfig.currency}',
                style: TextStyle(
                  color: WooAppTheme.colorCardCreateOrderText,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      );

  Widget _buildItemImage(
    BuildContext context,
    int id,
    String image,
  ) =>
      Container(
        width: 50,
        height: 50,
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => shimmer(),
          errorWidget: (context, url, error) => Center(
            child: Icon(Icons.error),
          ),
        ),
      );
}
