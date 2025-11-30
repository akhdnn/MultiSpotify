import 'package:flutter/material.dart';
import '../../../domain/entities/playlist_entity.dart';
import '../../widgets/playlist/playlist_card.dart';

class PlaylistPreviewList extends StatelessWidget {
  final List<PlaylistEntity> playlists;

  const PlaylistPreviewList({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    final recent = playlists.take(3).toList();

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recent.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          return SizedBox(
            width: 150,
            child: PlaylistCard(playlist: recent[i]),
          );
        },
      ),
    );
  }
}
