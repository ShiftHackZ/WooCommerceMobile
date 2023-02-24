import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/products_home_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/category.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/preferences/preferences_manager.dart';
import 'package:wooapp/screens/featured/featured_filter.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:wooapp/widget/widget_category.dart';
import 'package:wooapp/widget/widget_empty_state.dart';
import 'package:wooapp/widget/widget_filter.dart';
import 'package:wooapp/widget/widget_icon_notification.dart';
import 'package:wooapp/widget/widget_product_feed.dart';
import 'package:wooapp/widget/widget_product_grid.dart';
import 'package:wooapp/widget/widget_error_state.dart';
import 'package:wooapp/widget/widget_sort.dart';
import 'package:wooapp/screens/featured/featured_sort.dart';

//region FEATURED SCREEN WIDGETS
class FeaturedScreen extends StatelessWidget {
  final GlobalKey<_FeaturedListState> _keyList = GlobalKey();
  
  @override
  Widget build(BuildContext context) => FeaturedListView(key: _keyList);

  void applyListSettings() {
    _keyList.currentState?.applyListSettings();
  }
}

class FeaturedCategoriesView extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  final ValueSetter<VoidCallback> refreshCallback;

  FeaturedCategoriesView(this.context, this.refreshCallback);

  @override
  State<StatefulWidget> createState() => _FeaturedCategoriesViewState();

  @override
  Size get preferredSize => Size(MediaQuery.of(context).size.width, 150);
}

class FeaturedListView extends StatefulWidget {
  FeaturedListView({super.key});
  
  @override
  State<StatefulWidget> createState() => _FeaturedListState();
}
//endregion

//region FEATURED STATES
class _FeaturedListState extends State<FeaturedListView> {
  final ProductsHomeDataSource _ds =
      locator<ProductsHomeDataSource>();
  final PreferencesManager _preferences =
      locator<PreferencesManager>();
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  VoidCallback _categoryRefreshEvent = () {};

  Sort _sort = Sort.byDefault();
  FeaturedFilter _filter = FeaturedFilter.empty();
  TextEditingController _searchController = TextEditingController();

  double _priceMax = 10000.0;
  bool _displayGrid = true;
  bool _searchIconState = true;
  Timer? _debounce;

  @override
  void initState() {
    applyListSettings();
    _pagingController.addPageRequestListener((pageKey) => _fetchProducts(pageKey));
    _ds.getMostExpensiveProduct().then((max) {
      _priceMax = max;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: WooAppTheme.colorToolbarBackground,
      title: Container(
        padding: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: WooAppTheme.colorFeaturedSearchBackground,
          border: Border.all(
            color: WooAppTheme.colorFeaturedSearchBorder,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: TextField(
          controller: _searchController,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: WooAppTheme.colorToolbarForeground,
          ),
          onChanged: (query) {
            setState(() {
              _searchIconState = query.isEmpty;
            });
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(Duration(milliseconds: 700), () {
              if (query.length > 3) {
                setState(() {
                  _filter = _filter..search = query;
                });
                _pagingController.refresh();
              }
            });
          },
          cursorColor: WooAppTheme.colorToolbarForeground,
          decoration: InputDecoration(
            hintText: tr('search'),
            hintStyle: TextStyle(color: WooAppTheme.colorToolbarForeground),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: _searchIconState
                    ? Color(0x00FFFFFF)
                    : WooAppTheme.colorToolbarForeground,
              ),
              onPressed: () {
                _searchController.clear();
                _searchIconState = true;
                hideKeyboardForce(context);
                setState(() {
                  _filter = _filter..search = '';
                });
                _pagingController.refresh();
              },
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _preferences.setGridDisplayEnabled(!_displayGrid);
            setState(() => _displayGrid = !_displayGrid);
          },
          icon: Icon(
            _displayGrid
                ? Icons.grid_view_rounded
                : Icons.view_agenda_rounded,
            color: WooAppTheme.colorToolbarForeground,
          ),
        ),
        IconButton(
          onPressed: () => showWooBottomSheet(
            context,
            SortingWidget(_sort, SortingType.home, (newSort) {
              setState(() {
                _sort = newSort;
                _pagingController.refresh();
              });
            })
          ),
          icon: Icon(
            Icons.sort,
            color: WooAppTheme.colorToolbarForeground,
          ),
        ),
        IconButton(
          onPressed: () {
            showWooBottomSheet(
              context,
              FeaturedFilterWidget(
                _filter,
                (newFilter) {
                  setState(() {
                    _filter = newFilter;
                    _pagingController.refresh();
                  });
                },
                priceRangeMax: _priceMax,
              ),
            );
          },
          icon: NotificationIcon(
            icon: Icon(
              Icons.filter_alt_rounded,
              color: WooAppTheme.colorToolbarForeground,
            ),
            showDot: _filter.isApplied(),
          ),
        ),
      ],
    ),
    backgroundColor: WooAppTheme.colorCommonBackground,
    body: RefreshIndicator(
      onRefresh: () => Future.sync(() {
        _categoryRefreshEvent();
        _pagingController.refresh();
      }),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: 130,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: FeaturedCategoriesView(context, (refresh) {
                _categoryRefreshEvent = refresh;
              }),
            ),
          ),
          PagedSliverGrid(
            pagingController: _pagingController,
            showNewPageProgressIndicatorAsGridChild: false,
            showNewPageErrorIndicatorAsGridChild: false,
            showNoMoreItemsIndicatorAsGridChild: false,
            builderDelegate: PagedChildBuilderDelegate<Product>(
              itemBuilder: (context, item, index) => _displayGrid
                  ? ProductGridItem(
                      product: item,
                      detailRouteCallback: (_) {},
                    )
                  : ProductFeedWidget(
                      product: item,
                      onProductAction: () {},
                      onImageClicked: (_) {
                        hideKeyboardForce(context);
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
              newPageProgressIndicatorBuilder: (_) => _displayGrid
                  ? FeaturedShimmer(false)
                  : ProductFeedItemShimmer(),
              noItemsFoundIndicatorBuilder: (_) => WooEmptyStateWidget(
                keyTitle: 'featured_empty_title',
                keySubTitle: 'featured_empty_subtitle',
                action: WooEmptyStateAction(
                  buttonLabel: tr('featured_empty_action'),
                  buttonClick: () {
                    _searchController.clear();
                    _searchIconState = true;
                    hideKeyboardForce(context);
                    setState(() =>
                      _filter = _filter
                        ..clear()
                        ..search = '',
                    );
                    _categoryRefreshEvent();
                    _pagingController.refresh();
                  },
                ),
              ),
              firstPageErrorIndicatorBuilder: (_) => WooErrorStateWidget(() {
                _categoryRefreshEvent();
                _pagingController.refresh();
              }),
              newPageErrorIndicatorBuilder: (_) => CircularProgressIndicator()
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: _aspect(context),
              crossAxisCount: _displayGrid ? 2 : 1,
            ),
          ),
        ],
      ),
    )
  );
  
  void applyListSettings() {
    _preferences
        .getGridDisplayEnabled()
        .then((value) => setState(() => _displayGrid = value));
  }

  double _aspect(BuildContext context) {
    if (!_displayGrid) return 0.89;
    return MediaQuery.of(context).size.width /
        ((MediaQuery.of(context).size.height / 2) + 10);
  }

  Future<void> _fetchProducts(int page) async {
    try {
      final items = await _ds.getProducts(page, _sort, _filter).catchError((error, stackTrace) {
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

class _FeaturedCategoriesViewState extends State<FeaturedCategoriesView> {

  final ProductsHomeDataSource _ds = locator<ProductsHomeDataSource>();

  final PagingController<int, Category> _pagingController = PagingController(firstPageKey: 1);

  VoidCallback _refresher = () {};

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 120,
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Category>(
            itemBuilder: (_, item, i) => FeaturedCategoryWidget(item),
            firstPageProgressIndicatorBuilder: (_) =>
                FeaturedCategoriesShimmer(),
            firstPageErrorIndicatorBuilder: (_) => Container(),
          ),
          scrollDirection: Axis.horizontal,
        ),
      );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _fetchCategories(pageKey));
    _refresher = () { _pagingController.refresh(); };
    widget.refreshCallback(_refresher);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories(int page) async {
    try {
      final items = await _ds.getCategories(page);
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
//endregion
