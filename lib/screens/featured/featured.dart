import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:untitled/constants/config.dart';
import 'package:untitled/datasource/products_home_data_source.dart';
import 'package:untitled/extensions/extensions_context.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/model/category.dart';
import 'package:untitled/model/product.dart';
import 'package:untitled/screens/featured/featured_filter.dart';
import 'package:untitled/widget/shimmer.dart';
import 'package:untitled/widget/widget_category.dart';
import 'package:untitled/widget/widget_filter.dart';
import 'package:untitled/widget/widget_icon_notification.dart';
import 'package:untitled/widget/widget_product_grid.dart';
import 'package:untitled/widget/widget_retry.dart';
import 'package:untitled/widget/widget_sort.dart';

import 'featured_sort.dart';

class FeaturedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FeaturedListView();

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
  @override
  State<StatefulWidget> createState() => _FeaturedListState();
}

class _FeaturedListState extends State<FeaturedListView> {

  final ProductsHomeDataSource _ds = locator<ProductsHomeDataSource>();

  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 1);

  VoidCallback _categoryRefreshEvent = () {};

  Sort _sort = Sort.byDefault();
  FeaturedFilter _filter = FeaturedFilter.empty();
  TextEditingController _searchController = TextEditingController();

  double _priceMax = 10000.0;
  bool _searchIconState = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchProducts(pageKey));
    _ds.getMostExpensiveProduct().then((max) {
      _priceMax = max;
    });
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
      title: Container(
        padding: EdgeInsets.only(left: 8, top: 0),
        decoration: BoxDecoration(
          color: Color(0xFF50AAF1),
          border: Border.all(
            color: Color(0x808BC0EA)
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: TextField(
          controller: _searchController,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.search,
          style: TextStyle(color: Colors.white),
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
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: tr('search'),
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: _searchIconState ? Color(0x00FFFFFF) : Colors.white),
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
          onPressed: () => showBottomOptions(
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
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            showBottomOptions(
              context,
              FeaturedFilterWidget(_filter, (newFilter) {
                setState(() {
                  _filter = newFilter;
                  _pagingController.refresh();
                });
              }, priceRangeMax: _priceMax)
            );
          },
          icon: NotificationIcon(
            Icon(
              Icons.filter_alt_rounded,
              color: Colors.white,
            ),
            _filter.isApplied()
          ),
        ),
      ],
    ),
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
                  itemBuilder: (context, item, index) => ProductGridItem(item),
                  firstPageProgressIndicatorBuilder: (_) => FeaturedShimmer(true),
                  newPageProgressIndicatorBuilder: (_) => FeaturedShimmer(false),
                  firstPageErrorIndicatorBuilder: (_) => ErrorRetryWidget(() {
                    _categoryRefreshEvent();
                    _pagingController.refresh();
                  }),
                  newPageErrorIndicatorBuilder: (_) => CircularProgressIndicator()
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width / ((MediaQuery.of(context).size.height / 2) + 10),
                crossAxisCount: 2,
              )
          ),
        ],
      ),
    )
  );

  Future<void> _fetchProducts(int page) async {
    try {
      final items = await _ds.getProducts(page, _sort, _filter).catchError((error, stackTrace) {
        print(error.toString());
      });
      final isLast = items.length < AppConfig.paginationLimit;
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
        itemBuilder: (context, item, index) => FeaturedCategoryWidget(item),
        firstPageProgressIndicatorBuilder: (_) => FeaturedCategoriesShimmer(),
        firstPageErrorIndicatorBuilder: (_) => FeaturedCategoriesShimmer(),
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
      final items = await _ds.getCategories(page).catchError((error, stackTrace) {
        print(error.toString());
      });
      final isLast = items.length < AppConfig.paginationLimit;
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