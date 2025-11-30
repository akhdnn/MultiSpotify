import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistPreviewShimmer extends StatelessWidget {
  const PlaylistPreviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade900,
            highlightColor: Colors.grey.shade700,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }
}
