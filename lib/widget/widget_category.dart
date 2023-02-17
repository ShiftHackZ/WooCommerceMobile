import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/model/category.dart';
import 'package:wooapp/screens/category/category_screen.dart';

class FeaturedCategoryWidget extends StatelessWidget {
  final Category _category;

  FeaturedCategoryWidget(this._category);

  @override
  Widget build(BuildContext context) => Container(
    child: Column(
      children: [
        Container(
          width: 100,
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            color: WooAppTheme.colorCardProductBackground,
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(
                    _category.id,
                    _category.slug,
                    categoryTitle: _category.name,
                    categoryDesc: _category.description,
                    categoryImage: _category.image,
                  ),
                ),
              ),
              child: _buildImage(),
            ),
          ),
        ),
        Text(
          _category.name,
          style: TextStyle(
            color: WooAppTheme.colorCommonText,
          ),
        ),
      ],
    ),
  );

  Widget _buildImage() {
    if (_category.image != '') {
      return CachedNetworkImage(
        imageUrl: _category.image,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer(
          duration: Duration(seconds: 1),
          enabled: true,
          direction: ShimmerDirection.fromLTRB(),
          color: WooAppTheme.colorShimmerForeground,
          child: Container(
            color: WooAppTheme.colorShimmerBackground,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
    return Container(
      width: 100,
      height: 100,
      child: Center(
        child: Icon(Icons.error),
      ),
    );
  }
}
