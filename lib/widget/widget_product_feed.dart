import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/widget/widget_price_product.dart';
import 'package:wooapp/widget/widget_product_actions.dart';

class ProductFeedWidget extends StatelessWidget {
  final _sliderController = PageController();
  final _sliderNotifier = ValueNotifier<int>(0);

  final Product product;
  final Function() onProductAction;
  final Function(int index) onImageClicked;
  final bool displayWish;

  ProductFeedWidget({
    required this.product,
    required this.onProductAction,
    required this.onImageClicked,
    this.displayWish = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            child: _imageSlider(context, product),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 16),
              ProductPriceWidget.withProduct(product),
              Spacer(),
              RatingBarIndicator(
                rating: product.rating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: WooAppTheme.colorRatingActive,
                ),
                unratedColor: WooAppTheme.colorRatingNonActive,
                itemCount: 5,
                itemSize: 16,
                direction: Axis.horizontal,
              ),
              Text(
                ' ${product.rating.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: WooAppTheme.colorRatingText,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16,
            ),
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: WooAppTheme.colorCommonText,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16,
            ),
            child: ProductActionsWidget(
              product: product,
              changeCallback: () => onProductAction(),
              displayWish: displayWish,
            ),
          ),
        ],
      );

  Widget _imageSlider(BuildContext context, Product product) => GestureDetector(
        onTap: () => onImageClicked(_sliderController.page?.toInt() ?? 0),
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
            if (product.images.length > 1)
              Positioned(
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
          color: WooAppTheme.colorShimmerForeground,
          child: Container(
            color: WooAppTheme.colorShimmerBackground,
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Icon(Icons.error),
        ),
      );
}
