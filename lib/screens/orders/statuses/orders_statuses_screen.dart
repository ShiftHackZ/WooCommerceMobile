import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/widget/widget_order_status.dart';

class OrderStatusesScreen extends StatelessWidget {
  final ScrollController? scrollController;

  OrderStatusesScreen({this.scrollController});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: scrollController,
    physics: BouncingScrollPhysics(),
    child:  Column(
      children: [
        SizedBox(height: 16),
        Text(
          'order_status_dialog_title',
          style: TextStyle(
            color: WooAppTheme.colorCommonText,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ).tr(),
        SizedBox(height: 10),
        _buildStatusInfoCard(context, orderStatusPending),
        _buildStatusInfoCard(context, orderStatusOnHold),
        _buildStatusInfoCard(context, orderStatusProcessing),
        _buildStatusInfoCard(context, orderStatusCompleted),
        _buildStatusInfoCard(context, orderStatusRefunded),
        _buildStatusInfoCard(context, orderStatusCancelled),
        _buildStatusInfoCard(context, orderStatusFailed),
        _buildStatusInfoCard(context, orderStatusDraft),
        SizedBox(height: 12),
      ],
    ),
  );

  Widget _buildStatusInfoCard(BuildContext context, String status) => Container(
        margin: EdgeInsets.only(top: 8, right: 16, left: 16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: WooAppTheme.colorCardOrderBackground,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                OrderStatusWidget(
                  status: status,
                  minWidth: MediaQuery.of(context).size.width / 3.5,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _bindStatusTitle(status),
                    style: TextStyle(
                      color: WooAppTheme.colorCommonText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _bindStatusDescription(status),
              style: TextStyle(
                fontSize: 14,
                color: WooAppTheme.colorCommonText.withOpacity(0.95),
              ),
            ),
          ],
        ),
      );

  String _bindStatusTitle(String status) {
    switch (status) {
      case orderStatusDraft:
        return tr('order_status_draft_title');
      case orderStatusFailed:
        return tr('order_status_failed_title');
      case orderStatusRefunded:
        return tr('order_status_refunded_title');
      case orderStatusCancelled:
        return tr('order_status_canceled_title');
      case orderStatusCompleted:
        return tr('order_status_completed_title');
      case orderStatusOnHold:
        return tr('order_status_hold_title');
      case orderStatusPending:
        return tr('order_status_pending_title');
      case orderStatusProcessing:
        return tr('order_status_processing_title');
      default:
        return tr('order_status_draft');
    }
  }

  String _bindStatusDescription(String status) {
    switch (status) {
      case orderStatusDraft:
        return tr('order_status_draft_desc');
      case orderStatusFailed:
        return tr('order_status_failed_desc');
      case orderStatusRefunded:
        return tr('order_status_refunded_desc');
      case orderStatusCancelled:
        return tr('order_status_canceled_desc');
      case orderStatusCompleted:
        return tr('order_status_completed_desc');
      case orderStatusOnHold:
        return tr('order_status_hold_desc');
      case orderStatusPending:
        return tr('order_status_pending_desc');
      case orderStatusProcessing:
        return tr('order_status_processing_desc');
      default:
        return tr('order_status_draft');
    }
  }
}
