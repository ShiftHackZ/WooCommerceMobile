import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/catalog_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/category.dart';
import 'package:wooapp/screens/featured/featured_sort.dart';
import 'package:wooapp/widget/widget_catalog_item.dart';
import 'package:wooapp/widget/widget_sort.dart';

class CatalogScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogDataSource _ds = locator<CatalogDataSource>();

  final PagingController<int, Category> _pagingController = PagingController(firstPageKey: 1);

  Sort _sort = Sort(FaIcon(FontAwesomeIcons.sortAlphaDown), tr('sort_alphabet_asc'), 'asc', 'name');

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('tab_catalog').tr(),
      actions: [
        IconButton(
          onPressed: () => showBottomOptions(
              context,
              SortingWidget(_sort, SortingType.catalog, (newSort) {
                setState(() {
                  _sort = newSort;
                  _pagingController.refresh();
                });
              })
          ),
          icon: Icon(
            Icons.sort,
            color: Colors.white,
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: Container(
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Category>(
            itemBuilder: (context, item, index) => CatalogItemWidget(item),
          ),
          scrollDirection: Axis.vertical,
        ),
      ),
    ),
    // body: PagedGridView(
    //     pagingController: _pagingController,
    //     showNewPageProgressIndicatorAsGridChild: false,
    //     showNewPageErrorIndicatorAsGridChild: false,
    //     showNoMoreItemsIndicatorAsGridChild: false,
    //     builderDelegate: PagedChildBuilderDelegate<Category>(
    //         itemBuilder: (context, item, index) => CategoryGridItem(item),
    //         // firstPageProgressIndicatorBuilder: (_) => FeaturedShimmer(true),
    //         // newPageProgressIndicatorBuilder: (_) => FeaturedShimmer(false),
    //         firstPageErrorIndicatorBuilder: (_) => ErrorRetryWidget(() {
    //           _pagingController.refresh();
    //         }),
    //         newPageErrorIndicatorBuilder: (_) => CircularProgressIndicator()
    //     ),
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       // childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
    //       crossAxisCount: 2,
    //     )
    // ),
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
      final items = await _ds.getCategories(page, _sort).catchError((error, stackTrace) {
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