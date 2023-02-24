import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/orders_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/order.dart';
import 'package:wooapp/screens/orders/statuses/orders_statuses_screen.dart';
import 'package:wooapp/widget/widget_empty_state.dart';
import 'package:wooapp/widget/widget_error_state.dart';
import 'package:wooapp/widget/widget_order_item.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersDataSource _ds = locator<OrdersDataSource>();
  final PagingController<int, Order> _pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(
        color: WooAppTheme.colorToolbarForeground,
      ),
      title: Text('orders',
        style: TextStyle(
          color: WooAppTheme.colorToolbarForeground,
        ),
      ).tr(),
      backgroundColor: WooAppTheme.colorToolbarBackground,
      actions: [
        IconButton(
          onPressed: () => showWooScrollableBottomSheet(
            context,
            builder: (controller) => OrderStatusesScreen(
              scrollController: controller,
            ),
          ),
          icon: Icon(
            Icons.info,
            color: WooAppTheme.colorToolbarForeground,
          ),
        ),
      ],
    ),
    backgroundColor: WooAppTheme.colorCommonBackground,
    body: SafeArea(
      child: Container(
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Order>(
            itemBuilder: (context, item, index) => OrderItem(item),
            firstPageProgressIndicatorBuilder: (_) => _loadingState(),
            noItemsFoundIndicatorBuilder: (_) => WooEmptyStateWidget(
              mainAxisAlignment: MainAxisAlignment.center,
              keyTitle: 'orders_empty_title',
              keySubTitle: 'orders_empty_subtitle',
              action: WooEmptyStateAction(
                buttonLabel: tr('orders_empty_action'),
                buttonClick: () => Navigator.pop(context, true),
              ),
            ),
            firstPageErrorIndicatorBuilder: (_) => WooErrorStateWidget(() {
              _pagingController.refresh();
            }),
          ),
          scrollDirection: Axis.vertical,
        ),
      ),
    ),
  );

  Widget _loadingState() => Center(
    child: Lottie.asset('assets/animations/checkout_loader.json'),
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _fetch(pageKey));
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetch(int page) async {
    try {
      final items = await _ds.getOrders(page);
      final isLast = items.length < WooAppConfig.paginationLimit;
      if (isLast) {
        _pagingController.appendLastPage(items);
      } else {
        final next = page + 1;
        _pagingController.appendPage(items, next);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

}