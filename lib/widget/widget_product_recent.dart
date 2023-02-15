import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/database/product.dart';
import 'package:wooapp/extensions/extensions_context.dart';
import 'package:wooapp/screens/product/product_screen.dart';
import 'package:wooapp/widget/widget_price.dart';

class RecentProductItem extends StatelessWidget {

  final ViewedProduct product;
  final VoidCallback refreshCallback;

  RecentProductItem(this.product, this.refreshCallback);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      hideKeyboardForce(context);
      Navigator
          .push(context, MaterialPageRoute(builder: (_) => ProductScreen(product.id)))
          .then((value) {
        Future.delayed(Duration(milliseconds: 200), () {
          refreshCallback();
        });
        print('back, context = $context');
      });
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ProductScreen(product.id))
      // );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.all(2),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: (MediaQuery.of(context).size.height / 6),
            child: CachedNetworkImage(
              imageUrl: product.image,
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
                  child: Container(color: Colors.white10)
              ),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8, right: 4),
            child: Text(
              product.name,
              maxLines: 1,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, left: 8, right: 4),
            child: Row(
              children: [
                PriceWidget(product.price, ''),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
