import 'package:flutter/widgets.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';

Widget shimmer() => Shimmer(
    duration: Duration(seconds: 1),
    enabled: true,
    direction: ShimmerDirection.fromLTRB(),
    color: WooAppTheme.colorShimmerForeground,
    child: Container(color: WooAppTheme.colorShimmerBackground)
);
