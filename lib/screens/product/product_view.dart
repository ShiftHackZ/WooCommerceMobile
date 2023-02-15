import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/extensions/extensions_product.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/gallery/gallery.dart';
import 'package:wooapp/screens/product/product_cubit.dart';
import 'package:wooapp/screens/product/product_state.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/widget/widget_add_to_cart.dart';
import 'package:wooapp/widget/widget_attributes.dart';
import 'package:wooapp/widget/widget_price_product.dart';
import 'package:wooapp/widget/widget_product_actions.dart';
import 'package:wooapp/widget/widget_product_info.dart';
import 'package:wooapp/widget/widget_section.dart';
import 'package:wooapp/widget/widget_text_expanded.dart';

class ProductView extends StatelessWidget {
  final _sliderController = PageController();
  final _sliderNotifier = ValueNotifier<int>(0);

  ProductView();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
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
                  return _errorState();
                default:
                  return _loadingState();
              }
            },
          ),
        ),
      );

  Widget _loadingState() => ProductScreenShimmer();

  Widget _contentState(BuildContext context, Product product) => Scaffold(
    appBar: AppBar(title: Text('${product.name}')),
    bottomNavigationBar: AddToCartBottomBar(product),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            child: _imageSlider(context, product),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProductPriceWidget.withProduct(product),
                    Spacer(),
                    RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 12,
                      direction: Axis.horizontal,
                    ),
                    Text(' ${product.rating.toString()}')
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                ProductActionsWidget(
                  product: product,
                  addToWishList: () => context.read<ProductCubit>().addToWishList(),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: ExpandableText(
                    text: parseHtml(product.description),
                    length: 200,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                Divider(),
                SectionWidget(FontAwesomeIcons.thList, tr('product_attributes'), () {
                  _showAttributes(context, product);
                }),
                Divider(),
                SectionWidget(FontAwesomeIcons.infoCircle, tr('product_information'), () {
                  _showInfo(context, product);
                }),
              ],
            ),
          ),
          //if (product.attributes.length > 0) AttributesWidget(product.attributes)
        ],
      ),
    ),
  );

  Widget _imageSlider(BuildContext context, Product product) => GestureDetector(
    onTap: () => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => GalleryScreen(
        product.images.map((wooImg) => wooImg.src).toList(),
        initialPage: _sliderController.page!.toInt(),
      ))),
    child: Stack(
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          controller: _sliderController,
          children: [
            for (var image in product.images) _imageSingle(image.src)
          ],
          onPageChanged: (index) {
            _sliderNotifier.value = index;
          },
        ),
        if (product.images.length > 1) Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CirclePageIndicator(
              itemCount: product.images.length,
              currentPageNotifier: _sliderNotifier,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _imageSingle(String url) => CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer(
          duration: Duration(seconds: 1),
          enabled: true,
          direction: ShimmerDirection.fromLTRB(),
          child: Container(color: Colors.white10),
        ),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      );

  Widget _errorState() => Center(
        child: Text("Error"),
      );

  void _showAttributes(BuildContext context, Product product) {
    showBottomOptions(context, AttributesWidget(product.attributes));
  }

  void _showInfo(BuildContext context, Product product) {
    showBottomOptions(context, ProductInfoWidget(product));
  }
}