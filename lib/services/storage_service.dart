import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/playlist_model.dart';

class StorageService {
  static const String _playlistsKey = 'playlists';
  static const String _lastPlayedKey = 'last_played';
  static const String _shuffleKey = 'shuffle_enabled';
  static const String _repeatKey = 'repeat_mode';
  static const String _volumeKey = 'volume';
  static const String _audioQualityKey = 'audio_quality';

  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize SharedPreferences instance
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
    debugPrint('✅ StorageService initialized');
  }

  Future<SharedPreferences> _getPrefs() async {
    if (!_initialized) {
      await init();
    }
    return _prefs;
  }

  // Save playlists
  Future<void> savePlaylists(List<PlaylistModel> playlists) async {
    try {
      debugPrint('💾 [StorageService.savePlaylists] START - ${playlists.length} playlists');
      final prefs = await _getPrefs();
      final playlistsJson = playlists.map((p) => p.toJson()).toList();
      final encoded = json.encode(playlistsJson);
      
      // Save to SharedPreferences
      await prefs.setString(_playlistsKey, encoded);
      debugPrint('📋 [StorageService.savePlaylists] setString completed');
      
      // Verify data was written
      final saved = prefs.getString(_playlistsKey);
      if (saved != null && saved.isNotEmpty) {
        debugPrint('✅ [StorageService.savePlaylists] Verification SUCCESS: ${playlists.length} playlists (${encoded.length} bytes)');
      } else {
        debugPrint('❌ [StorageService.savePlaylists] Verification FAILED: Data not found after save');
      }
    } catch (e) {
      debugPrint('❌ [StorageService.savePlaylists] Error: $e');
      rethrow;
    }
  }

  // Get playlists
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      final prefs = await _getPrefs();
      final playlistsString = prefs.getString(_playlistsKey);

      if (playlistsString != null && playlistsString.isNotEmpty) {
        final List<dynamic> playlistsJson = json.decode(playlistsString);
        final playlists = playlistsJson
            .map((json) => PlaylistModel.fromJson(json))
            .toList();
        debugPrint('📋 Loaded ${playlists.length} playlists');
        return playlists;
      }
      debugPrint('📋 No playlists found in storage');
      return [];
    } catch (e) {
      debugPrint('❌ Error loading playlists: $e');
      return [];
    }
  }

  // Save last played song
  Future<void> saveLastPlayed(String songId) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_lastPlayedKey, songId);
    } catch (e) {
      debugPrint('❌ Error saving last played: $e');
    }
  }

  // Get last played song
  Future<String?> getLastPlayed() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_lastPlayedKey);
    } catch (e) {
      debugPrint('❌ Error getting last played: $e');
      return null;
    }
  }

  // Save shuffle state
  Future<void> saveShuffleState(bool enabled) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_shuffleKey, enabled);
      debugPrint('🔀 Shuffle state saved: $enabled');
    } catch (e) {
      debugPrint('❌ Error saving shuffle state: $e');
    }
  }

  // Get shuffle state
  Future<bool> getShuffleState() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getBool(_shuffleKey) ?? false;
    } catch (e) {
      debugPrint('❌ Error getting shuffle state: $e');
      return false;
    }
  }

  // Save repeat mode (0: off, 1: all, 2: one)
  Future<void> saveRepeatMode(int mode) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setInt(_repeatKey, mode);
      debugPrint('🔁 Repeat mode saved: $mode');
    } catch (e) {
      debugPrint('❌ Error saving repeat mode: $e');
    }
  }

  // Get repeat mode
  Future<int> getRepeatMode() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getInt(_repeatKey) ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting repeat mode: $e');
      return 0;
    }
  }

  // Save volume
  Future<void> saveVolume(double volume) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setDouble(_volumeKey, volume);
      debugPrint('🔊 Volume saved: $volume');
    } catch (e) {
      debugPrint('❌ Error saving volume: $e');
    }
  }

  // Get volume
  Future<double> getVolume() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getDouble(_volumeKey) ?? 1.0;
    } catch (e) {
      debugPrint('❌ Error getting volume: $e');
      return 1.0;
    }
  }

  Future<void> saveAudioQuality(String quality) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_audioQualityKey, quality);
      debugPrint('🎵 Audio quality saved: $quality');
    } catch (e) {
      debugPrint('❌ Error saving audio quality: $e');
    }
  }

  Future<String> getAudioQuality() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_audioQualityKey) ?? 'Cao';
    } catch (e) {
      debugPrint('❌ Error getting audio quality: $e');
      return 'Cao';
    }
  }

  /// Debug: Print all saved data
  Future<void> debugPrintAllData() async {
    try {
      final prefs = await _getPrefs();
      debugPrint('🔍 ===== DEBUG: All Saved Data =====');
      debugPrint('🔍 dark_mode: ${prefs.getBool('dark_mode')}');
      debugPrint('🔍 volume: ${prefs.getDouble(_volumeKey)}');
      debugPrint('🔍 shuffle_enabled: ${prefs.getBool(_shuffleKey)}');
      debugPrint('🔍 repeat_mode: ${prefs.getInt(_repeatKey)}');
      debugPrint('🔍 audio_quality: ${prefs.getString(_audioQualityKey)}');
      final playlists = prefs.getString(_playlistsKey);
      debugPrint('🔍 playlists length: ${playlists?.length ?? 0} chars');
      if (playlists != null) {
        debugPrint('🔍 playlists content: ${playlists.substring(0, min(200, playlists.length))}...');
      }
      debugPrint('🔍 ===== END DEBUG =====');
    } catch (e) {
      debugPrint('❌ Error in debugPrintAllData: $e');
    }
  }

  /// Force save all critical data immediately
  Future<void> forceFlushAllData({
    required bool isDarkMode,
    required double volume,
    required bool isShuffle,
    required int repeatMode,
    required String audioQuality,
    required List<PlaylistModel> playlists,
  }) async {
    try {
      debugPrint('💥 [FORCE FLUSH] Starting complete data flush...');
      final prefs = await _getPrefs();
      
      // Theme
      await prefs.setBool('dark_mode', isDarkMode);
      debugPrint('💥 [FORCE FLUSH] Theme saved: $isDarkMode');
      
      // Volume
      await prefs.setDouble(_volumeKey, volume);
      debugPrint('💥 [FORCE FLUSH] Volume saved: $volume');
      
      // Shuffle
      await prefs.setBool(_shuffleKey, isShuffle);
      debugPrint('💥 [FORCE FLUSH] Shuffle saved: $isShuffle');
      
      // Repeat
      await prefs.setInt(_repeatKey, repeatMode);
      debugPrint('💥 [FORCE FLUSH] Repeat saved: $repeatMode');
      
      // Audio quality
      await prefs.setString(_audioQualityKey, audioQuality);
      debugPrint('💥 [FORCE FLUSH] Audio quality saved: $audioQuality');
      
      // Playlists
      final playlistsJson = playlists.map((p) => p.toJson()).toList();
      final encoded = json.encode(playlistsJson);
      await prefs.setString(_playlistsKey, encoded);
      debugPrint('💥 [FORCE FLUSH] Playlists saved: ${playlists.length}');
      
      // Verify everything
      await debugPrintAllData();
      debugPrint('✅ [FORCE FLUSH] All data flushed successfully');
    } catch (e) {
      debugPrint('❌ [FORCE FLUSH] Error: $e');
      rethrow;
    }
  }
}
