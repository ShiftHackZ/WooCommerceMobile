import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/datasource/catalog_data_source.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_price.dart';
import 'package:wooapp/widget/widget_product_grid_slider.dart';

abstract class CatalogProductState {}

class ContentCatalogState extends CatalogProductState {
  List<Product> products;

  ContentCatalogState(this.products);
}

class EmptyCatalogState extends CatalogProductState {}

class CatalogProductCubit extends Cubit<CatalogProductState> {
  final CatalogDataSource _ds = locator<CatalogDataSource>();

  CatalogProductCubit() : super(EmptyCatalogState());

  void getProducts(int categoryId) {
    _ds.getCatalogProducts(categoryId).then((products) {
      emit(ContentCatalogState(products));
    }).catchError((error) {
      emit(EmptyCatalogState());
    });
  }
}

class CatalogProductsWidget extends StatelessWidget {
  final int categoryId;

  CatalogProductsWidget(this.categoryId);

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CatalogProductCubit(),
    child: CatalogProductsWidgetView(categoryId),
  );

}

class CatalogProductsWidgetView extends StatelessWidget {
  final int categoryId;

  CatalogProductsWidgetView(this.categoryId);

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<CatalogProductCubit>().getProducts(categoryId);
      },
      child: Container(
        child: BlocListener<CatalogProductCubit, CatalogProductState>(
          listener: (context, state) {},
          child: BlocBuilder<CatalogProductCubit, CatalogProductState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case ContentCatalogState:
                  return _buildContent(context, (state as  ContentCatalogState).products);
                default:
                  return _buildEmpty();
              }
            },
          ),
        ),
      )
  );

  Widget _buildEmpty() => Container(
    height: 150,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) => _buildShimmerItem(context)
    ),
  );

  Widget _buildContent(BuildContext context, List<Product> products) => Container(
    height: 150,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) => ProductGridSlidingWidget(product: products[index])
    ),
  );

  Widget _buildShimmerItem(BuildContext context) => Container(
    width: (MediaQuery.of(context).size.width / 2) + 32,
    height: 150,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: Shimmer(
              duration: Duration(seconds: 1),
              enabled: true,
              direction: ShimmerDirection.fromLTRB(),
              color: WooAppTheme.colorShimmerForeground,
              child: Container(
                color: WooAppTheme.colorShimmerBackground,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8, right: 4),
            child: Container(
              width: 200,
              height: 14,
              child: Shimmer(
                duration: Duration(seconds: 1),
                enabled: true,
                direction: ShimmerDirection.fromLTRB(),
                color: WooAppTheme.colorShimmerForeground,
                child: Container(
                  color: WooAppTheme.colorShimmerBackground,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, left: 8, right: 4),
            child: Container(
              width: 200,
              height: 14,
              child: Shimmer(
                duration: Duration(seconds: 1),
                enabled: true,
                direction: ShimmerDirection.fromLTRB(),
                color: WooAppTheme.colorShimmerForeground,
                child: Container(
                  color: WooAppTheme.colorShimmerBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
