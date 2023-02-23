import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/core/pop_controller.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/extensions/extensions_product.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/gallery/gallery.dart';
import 'package:wooapp/screens/product/product_cubit.dart';
import 'package:wooapp/screens/product/product_state.dart';
import 'package:wooapp/screens/viewed/viewed_products_screen.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/widget/widget_add_to_cart.dart';
import 'package:wooapp/widget/widget_attributes.dart';
import 'package:wooapp/widget/widget_catalog_products.dart';
import 'package:wooapp/widget/widget_price_product.dart';
import 'package:wooapp/widget/widget_product_actions.dart';
import 'package:wooapp/widget/widget_product_feed.dart';
import 'package:wooapp/widget/widget_product_info.dart';
import 'package:wooapp/widget/widget_error_state.dart';
import 'package:wooapp/widget/widget_text_expanded.dart';
import 'package:wooapp/widget/widget_woo_section.dart';

class ProductView extends StatelessWidget {
  final _willPopController = WillPopController();

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          backgroundColor: WooAppTheme.colorCommonBackground,
          body: BlocListener<ProductCubit, ProductState>(
            listener: (context, state) {},
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case InitialProductState:
                    return _loadingState();
                  case LoadingProductState:
                    return _loadingState();
                  case ContentProductState:
                    return _contentState(
                      context,
                      (state as ContentProductState).product,
                    );
                  case ErrorProductState:
                    return _errorState(context);
                  default:
                    return _loadingState();
                }
              },
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context, _willPopController.value);
          return Future(() => false);
        },
      );

  Widget _loadingState() => ProductScreenShimmer();

  Widget _contentState(BuildContext context, Product product) => Scaffold(
        appBar: _appBar(productName: '${product.name}'),
        backgroundColor: WooAppTheme.colorCommonBackground,
        bottomNavigationBar: AddToCartBottomBar(product),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductFeedWidget(
                product: product,
                displayWish: true,
                onProductAction: () => _willPopController.value = true,
                onImageClicked: (index) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GalleryScreen(
                      product.images.map((wooImg) => wooImg.src).toList(),
                      initialPage: index,
                    ),
                  ),
                ),
              ),
              if (product.hasDescription) Divider(),
              if (product.hasDescription)
                WooSectionHeading(tr('product_description')),
              if (product.hasDescription)
                Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                    right: 16,
                    left: 16,
                  ),
                  child: ExpandableText(
                    text: parseHtml(product.description),
                    length: 200,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: WooAppTheme.colorCommonText,
                    ),
                  ),
                ),
              if (product.attributes.length > 0) Divider(),
              if (product.attributes.length > 0)
                WooSectionHeading(tr('product_characteristics')),
              if (product.attributes.length > 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AttributesWidget(product.attributes),
                ),
              Divider(),
              ViewedProductsScreen(() {}),
              if (product.categories.isNotEmpty)
                CatalogProductsWidget(
                  product.categories[0].id,
                  height: 166,
                  itemPaddingHorizontal: 12,
                  excludedProductsIds: [product.id],
                  shrinkOnEmpty: true,
                  headerWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      WooSectionHeading(tr('product_from_same_category')),
                    ],
                  ),
                ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget _errorState(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: WooErrorStateWidget(
            () => context.read<ProductCubit>().getProduct(),
          ),
        ),
      );

  AppBar _appBar({String? productName}) => AppBar(
        leading: BackButton(
          color: WooAppTheme.colorToolbarForeground,
        ),
        title: Text(
          '${productName ?? ''}',
          style: TextStyle(
            color: WooAppTheme.colorToolbarForeground,
          ),
        ),
        backgroundColor: WooAppTheme.colorToolbarBackground,
      );

  void _showAttributes(BuildContext context, Product product) {
    showWooBottomSheet(context, AttributesWidget(product.attributes));
  }

  void _showInfo(BuildContext context, Product product) {
    showWooBottomSheet(context, ProductInfoWidget(product));
  }
}
