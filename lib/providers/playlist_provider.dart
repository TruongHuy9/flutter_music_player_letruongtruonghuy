import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../services/storage_service.dart';

class PlaylistProvider extends ChangeNotifier {
  final StorageService _storageService;
  final List<PlaylistModel> _playlists = [];

  List<SongModel> _allSongs = [];

  PlaylistProvider(this._storageService);

  List<PlaylistModel> get playlists => _playlists;

  void setAllSongs(List<SongModel> songs) {
    _allSongs = songs;
  }

  Future<void> loadPlaylists() async {
    try {
      final savedPlaylists = await _storageService.getPlaylists();
      debugPrint('📋 PlaylistProvider: Loaded ${savedPlaylists.length} playlists');
      _playlists
        ..clear()
        ..addAll(savedPlaylists);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading playlists: $e');
    }
  }

  Future<void> _savePlaylists() async {
    try {
      debugPrint('📋 PlaylistProvider: Saving ${_playlists.length} playlists');
      await _storageService.savePlaylists(_playlists);
      debugPrint('✅ Playlists saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving playlists: $e');
    }
  }

  PlaylistModel? getById(String id) {
    try {
      return _playlists.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<SongModel> getSongsOfPlaylist(String playlistId) {
    final playlist = getById(playlistId);
    if (playlist == null) return [];

    final List<SongModel> result = [];

    for (final songId in playlist.songIds) {
      final song = _allSongs.cast<SongModel?>().firstWhere(
            (s) => s?.id == songId,
            orElse: () => null,
          );

      if (song != null) {
        result.add(song);
      }
    }

    return result;
  }

  Future<void> createPlaylist(String name) async {
    _playlists.add(
      PlaylistModel(
        id: const Uuid().v4(),
        name: name,
        songIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    debugPrint('📋 PlaylistProvider: Created playlist "$name"');
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> renamePlaylist(String id, String newName) async {
    final index = _playlists.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _playlists[index] = _playlists[index].copyWith(
      name: newName,
      updatedAt: DateTime.now(),
    );
    debugPrint('📋 PlaylistProvider: Renamed playlist to "$newName"');
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> deletePlaylist(String id) async {
    _playlists.removeWhere((p) => p.id == id);
    debugPrint('📋 PlaylistProvider: Deleted playlist');
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> addSongToPlaylist(String playlistId, SongModel song) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];

    if (!playlist.songIds.contains(song.id)) {
      _playlists[index] = playlist.copyWith(
        songIds: [...playlist.songIds, song.id],
        updatedAt: DateTime.now(),
      );
      debugPrint('📋 PlaylistProvider: Added "${song.title}" to playlist');
      await _savePlaylists();
      notifyListeners();
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return;

    final playlist = _playlists[index];

    _playlists[index] = playlist.copyWith(
      songIds: playlist.songIds.where((id) => id != songId).toList(),
      updatedAt: DateTime.now(),
    );
    debugPrint('📋 PlaylistProvider: Removed song from playlist');
    await _savePlaylists();
    notifyListeners();
  }

  /// Save all data (called on app close)
  Future<void> saveAllData() async {
    debugPrint('💾 PlaylistProvider.saveAllData() called');
    await _savePlaylists();
  }
}
