import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/database/entity/product.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/widget/widget_price.dart';

class ProductGridSlidingWidget extends StatelessWidget {
  final Product? product;
  final ViewedProduct? viewedProduct;

  ProductGridSlidingWidget({this.product, this.viewedProduct});

  @override
  Widget build(BuildContext context) => Container(
    width: (MediaQuery.of(context).size.width / 2) + 32,
    height: 150,
    child: InkWell(
      onTap: () {
        hideKeyboardForce(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen(product?.id ?? viewedProduct?.id ?? 0)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: WooAppTheme.colorCardProductBackground,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              child: CachedNetworkImage(
                imageUrl: _bindImageUrl(),
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 8, right: 4),
              child: Text(
                product?.name ?? viewedProduct?.name ?? '',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: WooAppTheme.colorCardProductText,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 8, right: 4),
              child: Row(
                children: [
                  if (product != null)
                    PriceWidget.withProduct(product!),
                  if (viewedProduct != null)
                    PriceWidget(viewedProduct!.price, ''),
                  Spacer(),
                  if (product != null) RatingBarIndicator(
                    rating: product?.rating ?? 0,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: WooAppTheme.colorRatingActive,
                    ),
                    unratedColor: WooAppTheme.colorRatingNonActive,
                    itemCount: 5,
                    itemSize: 12,
                    direction: Axis.horizontal,
                  ),
                  if (product != null) Text(' ${product?.rating.toString()}',
                    style: TextStyle(
                      color: WooAppTheme.colorRatingText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  String _bindImageUrl() {
    if (product != null) {
      return product!.images.length != 0 ? product!.images[0].src : '';
    }
    if (viewedProduct != null) {
      return viewedProduct?.image ?? '';
    }
    return '';
  }
}
