import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/orders_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/order.dart';
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
      title: Text('orders').tr(),
      backgroundColor: WooAppTheme.colorCommonToolbar,
    ),
    backgroundColor: WooAppTheme.colorCommonBackground,
    body: SafeArea(
      child: Container(
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Order>(
            itemBuilder: (context, item, index) => OrderItem(item),
          ),
          scrollDirection: Axis.vertical,
        ),
      ),
    ),
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
      final items = await _ds.getOrders(page).catchError((error, stackTrace) {
        print(error.toString());
      });
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