import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';

class AddSongModal extends ConsumerWidget {
  final String playlistId;
  final String userId;

  const AddSongModal({
    super.key,
    required this.playlistId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsState = ref.watch(songsControllerProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: songsState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (songs) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tambah Lagu ke Playlist",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: songs
                    .map(
                      (song) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(song.coverUrl),
                        ),
                        title: Text(song.title,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(song.artist,
                            style:
                                const TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.add,
                              color: Colors.greenAccent),
                          onPressed: () async {
                            await ref
                                .read(playlistControllerProvider.notifier)
                                .addToPlaylist(
                                  playlistId,
                                  song.id,
                                  userId,
                                );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
        error: (e, s) => Text(
          "Error: $e",
          style: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
