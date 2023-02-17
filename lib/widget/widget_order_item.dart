import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/model/line_item.dart';
import 'package:wooapp/model/order.dart';
import 'package:wooapp/widget/widget_custom_spacer.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        child: Card(
          color: WooAppTheme.colorCardOrderBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              _buildHeader(context),
              _buildLineItems(context),
              SizedBox(height: 12),
            ],
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderNumber(),
                SizedBox(height: 4),
                _buildOrderCreateDate()
              ],
            ),
            Spacer(),
            OrderStatus(order.status),
          ],
        ),
      );

  Widget _buildLineItems(BuildContext context) => Container(
        margin: EdgeInsets.only(right: 12, left: 12, top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var lineItem in order.lineItems)
              _buildLineItem(context, lineItem),
            _buildOrderTotal()
          ],
        ),
      );

  Widget _buildLineItem(BuildContext context, LineItem item) => Container(
        margin: EdgeInsets.only(top: 4),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 8),
              child: DotSpacer(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Container(
                    color: WooAppTheme.colorCardOrderBackground,
                    child: Text(
                      '${item.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: WooAppTheme.colorCardOrderForeground,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: WooAppTheme.colorCardOrderBackground,
                  child: Text(
                    '${item.quantity} x ${item.price}${WooAppConfig.currency}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: WooAppTheme.colorCardOrderForeground,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildOrderTotal() => Container(
        margin: EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Text(
              'order_item_total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: WooAppTheme.colorCardOrderForeground,
              ),
            ).tr(),
            DotSpacer(),
            Text(
              '${order.total}${WooAppConfig.currency}',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: WooAppTheme.colorCardOrderForeground,
              ),
            )
          ],
        ),
      );

  Widget _buildOrderCreateDate() => Row(
    children: [
      // FaIcon(FontAwesomeIcons.clock),
      // SizedBox(width: 8),
      Text(
        '${tr('order_item_date')}: ${order.dateCreated}',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: WooAppTheme.colorCardOrderForeground,
        ),
      ),
    ],
  );

  Widget _buildOrderNumber() => Row(
        children: [
          FaIcon(
            FontAwesomeIcons.boxOpen,
            color: WooAppTheme.colorCardOrderForeground,
          ),
          SizedBox(width: 8),
          Text(
            '${tr('order')} #${order.id}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: WooAppTheme.colorCardOrderForeground,
            ),
          ),
        ],
      );
}

class OrderStatus extends StatelessWidget {
  final String status;

  OrderStatus(this.status);

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(status),
        ),
      );
}
