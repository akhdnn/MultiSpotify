import 'package:flutter/material.dart';
import '../shimmer/shimmer_box.dart';

class PlaylistHeaderShimmer extends StatelessWidget {
  const PlaylistHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 20),
        ShimmerBox(height: 140, width: 140, radius: 20),
        SizedBox(height: 20),
        ShimmerBox(height: 22, width: 180),
        SizedBox(height: 10),
        ShimmerBox(height: 18, width: 240),
      ],
    );
  }
}
