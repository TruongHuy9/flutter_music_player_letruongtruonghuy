import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/audio_provider.dart';
import '../services/storage_service.dart';

class AppLifecycleManager with WidgetsBindingObserver {
  final ThemeProvider themeProvider;
  final PlaylistProvider playlistProvider;
  final AudioProvider audioProvider;
  final StorageService storageService;

  AppLifecycleManager({
    required this.themeProvider,
    required this.playlistProvider,
    required this.audioProvider,
    required this.storageService,
  });

  void init() {
    WidgetsBinding.instance.addObserver(this);
    debugPrint('🔄 AppLifecycleManager initialized');
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('🔄 AppLifecycleManager disposed');
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        debugPrint('📤 App is detached - saving all data');
        await _saveAllData();
        break;
      case AppLifecycleState.paused:
        debugPrint('⏸️ App is paused - saving all data');
        await _saveAllData();
        break;
      case AppLifecycleState.resumed:
        debugPrint('▶️ App is resumed');
        break;
      case AppLifecycleState.inactive:
        debugPrint('⏳ App is inactive');
        break;
      case AppLifecycleState.hidden:
        debugPrint('🔒 App is hidden - saving all data');
        await _saveAllData();
        break;
    }
  }

  Future<void> _saveAllData() async {
    try {
      debugPrint('💾 [AppLifecycleManager] Starting save all data...');
      
      // Collect all data
      final isDarkMode = themeProvider.isDarkMode;
      final volume = audioProvider.volume;
      final isShuffle = audioProvider.isShuffleEnabled;
      final repeatMode = audioProvider.loopMode.index;
      final audioQuality = audioProvider.audioQuality;
      final playlists = playlistProvider.playlists;
      
      debugPrint('💾 [AppLifecycleManager] Collected data:');
      debugPrint('  - isDarkMode: $isDarkMode');
      debugPrint('  - volume: $volume');
      debugPrint('  - isShuffle: $isShuffle');
      debugPrint('  - repeatMode: $repeatMode');
      debugPrint('  - audioQuality: $audioQuality');
      debugPrint('  - playlists: ${playlists.length}');
      
      // Use force flush for all data
      await storageService.forceFlushAllData(
        isDarkMode: isDarkMode,
        volume: volume,
        isShuffle: isShuffle,
        repeatMode: repeatMode,
        audioQuality: audioQuality,
        playlists: playlists,
      );
      
      debugPrint('✅ [AppLifecycleManager] Save all data completed');
    } catch (e) {
      debugPrint('❌ [AppLifecycleManager] Error saving app data: $e');
    }
  }
}
