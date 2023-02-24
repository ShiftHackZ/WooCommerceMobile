import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/category_attribute_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/preferences/preferences_manager.dart';
import 'package:wooapp/screens/category/fliter/category_filter_screen.dart';
import 'package:wooapp/screens/category/info/category_info_screen.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:wooapp/widget/widget_empty_state.dart';
import 'package:wooapp/widget/widget_product_feed.dart';
import 'package:wooapp/widget/widget_product_grid.dart';
import 'package:wooapp/widget/widget_error_state.dart';

class CategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categorySlug;
  final String categoryTitle;
  final String categoryDesc;
  final String categoryImage;

  CategoryScreen(
    this.categoryId,
    this.categorySlug, {
    this.categoryTitle = '',
    this.categoryDesc = '',
    this.categoryImage = '',
  });

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PreferencesManager _preferences =
      locator<PreferencesManager>();
  final CategoryAttributeDateSource _ds =
      locator<CategoryAttributeDateSource>();
  final PagingController<int, CategoryProduct> _pagingController =
      PagingController(firstPageKey: 1);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _displayGrid = true;

  @override
  void initState() {
    // ToDo [Feed]: disabling feed list mode due to lack of fields from category API.
    // _preferences
    //     .getGridDisplayEnabled()
    //     .then((value) => setState(() => _displayGrid = value));

    _pagingController
        .addPageRequestListener((pageKey) => _fetchProducts(pageKey));

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.categoryTitle,
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ),
          backgroundColor: WooAppTheme.colorToolbarBackground,
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: WooAppTheme.colorToolbarForeground,
          ),
          actions: [
            // ToDo [Feed]: disabling feed list mode due to lack of fields from category API.
            // IconButton(
            //   onPressed: () {
            //     _preferences.setGridDisplayEnabled(!_displayGrid);
            //     setState(() => _displayGrid = !_displayGrid);
            //   },
            //   icon: Icon(
            //     _displayGrid
            //         ? Icons.grid_view_rounded
            //         : Icons.view_agenda_rounded,
            //     color: WooAppTheme.colorToolbarForeground,
            //   ),
            // ),
            if (widget.categoryDesc.isNotEmpty)
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryInfoScreen(
                      widget.categoryTitle,
                      widget.categoryDesc,
                      widget.categoryImage,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.info,
                  color: WooAppTheme.colorToolbarForeground,
                ),
              ),
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(
                Icons.filter_alt_rounded,
                color: WooAppTheme.colorToolbarForeground,
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: CategoryFilterScreen(() {
            _pagingController.refresh();
          }),
        ),
        backgroundColor: WooAppTheme.colorCommonBackground,
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            _pagingController.refresh();
          }),
          child: PagedGridView(
            pagingController: _pagingController,
            showNewPageErrorIndicatorAsGridChild: false,
            showNewPageProgressIndicatorAsGridChild: false,
            showNoMoreItemsIndicatorAsGridChild: false,
            builderDelegate: PagedChildBuilderDelegate<CategoryProduct>(
              itemBuilder: (ctx, item, index) => _displayGrid
                  ? CategoryProductGridItem(item)
                  : ProductFeedWidget(
                      categoryProduct: item,
                      onProductAction: () {},
                      onImageClicked: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductScreen(item.id),
                          ),
                        );
                      },
                    ),
              firstPageProgressIndicatorBuilder: (_) => _displayGrid
                  ? FeaturedShimmer(true)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductFeedItemShimmer(),
                        ProductFeedItemShimmer(),
                      ],
                    ),
              firstPageErrorIndicatorBuilder: (_) => WooErrorStateWidget(() {
                _pagingController.refresh();
              }),
              noItemsFoundIndicatorBuilder: (_) => WooEmptyStateWidget(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              newPageProgressIndicatorBuilder: (_) => _displayGrid
                  ? FeaturedShimmer(false)
                  : ProductFeedItemShimmer(),
              newPageErrorIndicatorBuilder: (_) => CircularProgressIndicator(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _displayGrid ? 2 : 1,
              childAspectRatio: _aspect(context),
            ),
          ),
        ),
      );

  double _aspect(BuildContext context) {
    if (!_displayGrid) return 0.89;
    return MediaQuery.of(context).size.width /
        ((MediaQuery.of(context).size.height / 2) + 10);
  }

  Future<void> _fetchProducts(int page) async {
    try {
      final items = await _ds.getProducts(widget.categorySlug, page);
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
