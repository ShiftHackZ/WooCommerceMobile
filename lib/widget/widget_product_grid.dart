import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/widget/widget_price.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final Function(dynamic) detailRouteCallback;

  ProductGridItem({
    required this.product,
    required this.detailRouteCallback,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      hideKeyboardForce(context);
      var result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductScreen(product.id))
      );
      if (result != null) {
        detailRouteCallback(result);
      }
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
            height: (MediaQuery.of(context).size.height / 6),
            child: CachedNetworkImage(
              imageUrl: product.images.length != 0 ? product.images[0].src : '',
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
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8, right: 4),
            child: Text(
              product.name,
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
                PriceWidget.withProduct(product),
                Spacer(),
                RatingBarIndicator(
                  rating: product.rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: WooAppTheme.colorRatingActive,
                  ),
                  unratedColor: WooAppTheme.colorRatingNonActive,
                  itemCount: 5,
                  itemSize: 12,
                  direction: Axis.horizontal,
                ),
                Text(
                  ' ${product.rating.toString()}',
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
  );
}

class CategoryProductGridItem extends StatelessWidget {
  final CategoryProduct _product;

  const CategoryProductGridItem(this._product);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      hideKeyboardForce(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen(_product.id))
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
            height: (MediaQuery.of(context).size.height / 6),
            child: CachedNetworkImage(
              imageUrl: _product.image,
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
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8, right: 4),
            child: Text(
              _product.name,
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
                PriceWidget(_product.price, _product.salePrice),
                Spacer(),
                // RatingBarIndicator(
                //   rating: _product.rating,
                //   itemBuilder: (context, index) => Icon(
                //     Icons.star,
                //     color: Colors.amber,
                //   ),
                //   itemCount: 5,
                //   itemSize: 12,
                //   direction: Axis.horizontal,
                // ),
                // Text(' ${_product.rating.toString()}')
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
