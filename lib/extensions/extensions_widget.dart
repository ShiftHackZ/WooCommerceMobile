import 'package:flutter/widgets.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

Widget shimmer() => Shimmer(
    duration: Duration(seconds: 1),
    enabled: true,
    direction: ShimmerDirection.fromLTRB(),
    child: Container(color: Color(0x11000000))
);
