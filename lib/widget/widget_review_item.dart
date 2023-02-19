import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/extensions/extensions_product.dart';
import 'package:wooapp/model/product_rewiew.dart';

class ReviewItemWidget extends StatelessWidget {
  static const double avatarSize = 26;

  final ProductReview review;

  ReviewItemWidget(this.review);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: WooAppTheme.colorSecondaryBackground.withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              '${review.reviewer}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: WooAppTheme.colorCardProductText,
                              ),
                            ),
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
                            itemSize: 16,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '${review.rating}',
                            style: TextStyle(
                              color: WooAppTheme.colorRatingText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        parseHtml(review.review),
                        style: TextStyle(
                          color: WooAppTheme.colorCardProductText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
      );
}
