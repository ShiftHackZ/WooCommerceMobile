import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';

const orderStatusDraft = 'checkout-draft';
const orderStatusFailed = 'failed';
const orderStatusRefunded = 'refunded';
const orderStatusCancelled = 'cancelled';
const orderStatusCompleted = 'completed';
const orderStatusOnHold = 'on-hold';
const orderStatusPending = 'pending';
const orderStatusProcessing = 'processing';

class OrderStatusWidget extends StatelessWidget {
  final String status;

  OrderStatusWidget({required this.status});

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        color: bindBgColorForOrderStatus(status),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            bindTextLabelForOrderStatus(status),
            style: TextStyle(
              color: bindTextColorForOrderStatus(status),
            ),
          ),
        ),
      );
}

Color bindBgColorForOrderStatus(String status) {
  switch (status) {
    case orderStatusDraft:
      return WooAppTheme.colorOrderStatusBgGray;
    case orderStatusFailed:
      return WooAppTheme.colorOrderStatusBgRed;
    case orderStatusRefunded:
      return WooAppTheme.colorOrderStatusBgPink;
    case orderStatusCancelled:
      return WooAppTheme.colorOrderStatusBgRed.withOpacity(0.55);
    case orderStatusCompleted:
      return WooAppTheme.colorOrderStatusBgGreen;
    case orderStatusOnHold:
      return WooAppTheme.colorOrderStatusBgYellow;
    case orderStatusPending:
      // return WooAppTheme.colorOrderStatusBgGray2;
      return WooAppTheme.colorOrderStatusBgGray;
    case orderStatusProcessing:
      return WooAppTheme.colorOrderStatusBgBlue;
    default:
      return WooAppTheme.colorOrderStatusBgGray;
  }
}

Color bindTextColorForOrderStatus(String status) {
  switch (status) {
    case orderStatusDraft:
      return WooAppTheme.colorOrderStatusTextGray;
    case orderStatusFailed:
      return WooAppTheme.colorOrderStatusTextRed;
    case orderStatusRefunded:
      return WooAppTheme.colorOrderStatusTextPink;
    case orderStatusCancelled:
      return WooAppTheme.colorOrderStatusTextRed;
    case orderStatusCompleted:
      return WooAppTheme.colorOrderStatusTextGreen;
    case orderStatusOnHold:
      return WooAppTheme.colorOrderStatusTextYellow;
    case orderStatusPending:
      return WooAppTheme.colorOrderStatusTextGray;
      // return WooAppTheme.colorOrderStatusTextGray2;
    case orderStatusProcessing:
      return WooAppTheme.colorOrderStatusTextBlue;
    default:
      return WooAppTheme.colorOrderStatusTextGray;
  }
}

String bindTextLabelForOrderStatus(String status) {
  switch (status) {
    case orderStatusDraft:
      return tr('order_status_draft');
    case orderStatusFailed:
      return tr('order_status_failed');
    case orderStatusRefunded:
      return tr('order_status_refunded');
    case orderStatusCancelled:
      return tr('order_status_canceled');
    case orderStatusCompleted:
      return tr('order_status_completed');
    case orderStatusOnHold:
      return tr('order_status_hold');
    case orderStatusPending:
      return tr('order_status_pending');
    case orderStatusProcessing:
      return tr('order_status_processing');
    default:
      return tr('order_status_draft');
  }
}
