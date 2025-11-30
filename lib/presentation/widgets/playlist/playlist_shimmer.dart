import 'package:flutter/material.dart';

class PlaylistShimmer extends StatelessWidget {
  const PlaylistShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 14,
            width: 90,
            color: Colors.white12,
          ),
          const SizedBox(height: 6),
          Container(
            height: 12,
            width: 60,
            color: Colors.white10,
          ),
        ],
      ),
    );
  }
}
