import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../domain/entities/song_entity.dart';
import '../../application/songs/fetch_all_songs_usecase.dart';
import '../../application/songs/upload_song_usecase.dart';
import '../../presentation/pages/songs/search_songs_usecase.dart';
import '../../infrastructure/local/search_local_datasource.dart';
import '../../core/di/providers.dart';

class SongsController extends StateNotifier<AsyncValue<List<SongEntity>>> {
  final FetchAllSongsUsecase fetchSongs;
  final UploadSongUsecase uploadSongUsecase;
  final SearchSongsUsecase searchSongsUsecase;
  final SearchLocalDatasource local;
  final Ref ref;

  // temporary storage lagu baru
  List<SongEntity> allSongs = [];
  List<SongEntity> mySongs = [];

  Timer? debounceTimer;

  List<String> recentSearch = [];
  String searchCategory = "song";

  SongsController(
    this.fetchSongs,
    this.uploadSongUsecase,
    this.searchSongsUsecase,
    this.local, {
    required this.ref,
  }) : super(const AsyncValue.loading()) {
    loadRecent();
    loadAllSongs();
  }

  // load recent search
  Future<void> loadRecent() async {
    recentSearch = await local.getRecent();
  }

  // update search category
  void updateCategory(String cat) {
    searchCategory = cat;
  }

  // debounce
  Future<void> searchDebounce(String keyword) async {
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      search(keyword);
    });
  }

  // upload lagu
  Future<void> uploadSong(SongEntity song) async {
    try {
      await uploadSongUsecase.execute(song);

      // Reload setelah upload
      await loadAllSongs();

    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // load semua lagu (global)
  Future<void> loadAllSongs() async {
    state = const AsyncValue.loading();

    try {
      final result = await fetchSongs.execute();

      allSongs = result;

      state = AsyncValue.data(allSongs);

    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // load songs punya user
  Future<void> loadMySongs(String userId) async {
    try {
      final data = await fetchSongs.execute();

      mySongs = data.where((s) => s.uploaderId == userId).toList();

      // state tidak berubah = tetap allSongs untuk HomePage
      // kalau ingin state menjadi mySongs, panggil manual

    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // search lagu dan artists
  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      state = AsyncValue.data([]);
      return;
    }

    local.addRecent(keyword);
    state = const AsyncValue.loading();

    try {
      if (searchCategory == "song") {
        final results = await searchSongsUsecase.execute(keyword);
        state = AsyncValue.data(results);
      } else {
        final artists =
            await ref.read(songRepositoryProvider).searchArtists(keyword);

        final artistSongs = artists
            .map(
              (a) => SongEntity(
                id: a,
                title: "Artis: $a",
                artist: a,
                coverUrl: "",
                audioUrl: "",
                uploaderId: "",
              ),
            )
            .toList();

        state = AsyncValue.data(artistSongs);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
