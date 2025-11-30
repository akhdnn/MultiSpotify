import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import 'playlist_preview_list.dart';
import 'playlist_preview_shimmer.dart';
import 'profile_edit_modal.dart';

class ProfilePanel extends ConsumerStatefulWidget {
  const ProfilePanel({super.key});

  @override
  ConsumerState<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends ConsumerState<ProfilePanel> {
  double avatarOffset = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = ref.read(authControllerProvider);
      if (user != null) {
        ref
            .read(playlistControllerProvider.notifier)
            .loadPlaylistsWithoutSongs(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final playlists = ref.watch(playlistControllerProvider);

    final initial = (user?.email.isNotEmpty ?? false)
        ? user!.email[0].toUpperCase()
        : "?";

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (scroll) {
        avatarOffset = (scroll.metrics.pixels * 0.20).clamp(0, 36);
        setState(() {});
        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          color: Color(0xFF0C0C0C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 230,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    // GRADIENT
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF262626), Color(0xFF0C0C0C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    // PARALLAX AVATAR
                    Transform.translate(
                      offset: Offset(0, avatarOffset),
                      child: Hero(
                        tag: "profile-avatar",
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white24,
                          child: Text(
                            initial,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 46,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BODY
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // EMAIL
                    Text(
                      user?.email ?? "(no email)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // EDIT PROFILE BTN
                    ElevatedButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ProfileEditModal(),
                      ),
                      child: const Text("Edit Profil"),
                    ),

                    const SizedBox(height: 30),

                    // PLAYLIST SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Playlist Kamu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Kelola",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      ],
                    ),

                    // Counter
                    playlists.maybeWhen(
                      data: (list) => Text(
                        "${list.length} Playlist",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                      orElse: () => const SizedBox(),
                    ),
                    const SizedBox(height: 16),

                    // PLAYLIST PREVIEW
                    playlists.when(
                      loading: () => const PlaylistPreviewShimmer(),
                      error: (e, s) => Text(
                        "Error: $e",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      data: (list) => list.isEmpty
                          ? const Text(
                              "Belum ada playlist.",
                              style: TextStyle(color: Colors.white54),
                            )
                          : PlaylistPreviewList(playlists: list),
                    ),

                    const SizedBox(height: 30),

                    // LOGOUT
                    ElevatedButton(
                      onPressed: () async {
                        await ref.read(authControllerProvider.notifier).logout();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Logout"),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
