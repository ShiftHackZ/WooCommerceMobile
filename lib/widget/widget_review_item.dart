import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/colors.dart';
import 'package:wooapp/extensions/extensions_product.dart';
import 'package:wooapp/model/product_rewiew.dart';

class ReviewItemWidget extends StatelessWidget {
  static const double avatarSize = 26;

  final ProductReview review;

  ReviewItemWidget(this.review);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${review.reviewer}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      RatingBarIndicator(
                        rating: review.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: WooAppTheme.colorRatingActive,
                        ),
                        unratedColor: WooAppTheme.colorRatingNonActive,
                        itemCount: 5,
                        itemSize: 12,
                        direction: Axis.horizontal,
                      ),
                      Text(' ${review.rating.toString()}')
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(parseHtml(review.review)),
                ],
              )
            ),
          ],
        ),
      ),
      Divider()
    ],
  );

  Widget _buildAvatar() => CircleAvatar(
    backgroundColor: Colors.blueGrey,
    radius: avatarSize,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(avatarSize)),
      child: CachedNetworkImage(
          imageUrl: review.reviewerAvatar.x48,
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
  );
}
