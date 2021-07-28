import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget WrapWithShimmer({required Widget child}) {
  return Shimmer.fromColors(
    enabled: true,
    baseColor: Colors.black.withOpacity(0.3),
    highlightColor: Colors.black.withOpacity(0.1),
    child: child,
  );
}