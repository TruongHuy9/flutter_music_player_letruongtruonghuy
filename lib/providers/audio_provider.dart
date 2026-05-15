import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';
import '../services/storage_service.dart';
import '../models/playback_state_model.dart';

  class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService;
  final StorageService _storageService;

  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffleEnabled = false;
  LoopMode _loopMode = LoopMode.off;

  AudioProvider(this._audioService, this._storageService) {
  _init();
  }

    PlaybackUiState  get currentPlaybackState => PlaybackUiState (
    position: _audioService.currentPosition,
    duration: _audioService.currentDuration ?? Duration.zero,
    isPlaying: _audioService.isPlaying,
  );

  bool get isPlaying => _audioService.isPlaying;
  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  SongModel? get currentSong => _playlist.isEmpty ? null :
  _playlist[_currentIndex];
  bool get isShuffleEnabled => _isShuffleEnabled;
  LoopMode get loopMode => _loopMode;
  double _volume = 1.0;
  String _audioQuality = 'Cao';
  double get volume => _volume;
  String get audioQuality => _audioQuality;

  Stream<Duration> get positionStream => _audioService.positionStream;
  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<bool> get playingStream => _audioService.playingStream;
  Stream<PlaybackUiState > get playbackStateStream =>
  _audioService.playbackStateStream;

  Future<void> _init() async {
  _isShuffleEnabled = await _storageService.getShuffleState();
  final repeatMode = await _storageService.getRepeatMode();
  _loopMode = LoopMode.values[repeatMode];
  await _audioService.setLoopMode(_loopMode);

  final volume = await _storageService.getVolume();
  _volume = volume;
  await _audioService.setVolume(volume);
  _audioQuality = await _storageService.getAudioQuality();

  // Tải nhạc từ asset ngay khi khởi tạo (không cần quyền vì dùng asset)
  await loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      // Dùng AssetManifest API để load tất cả audio files
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final audioPaths = assetManifest
          .listAssets()
          .where((String key) => key.startsWith('lib/assets/audio/sample_songs/') && key.endsWith('.mp3'))
          .toList();

      debugPrint('🎵 Found ${audioPaths.length} songs in assets');

      // Load available image assets
      final imageAssets = assetManifest
          .listAssets()
          .where((String key) => key.startsWith('lib/assets/images/') && key.endsWith('.png'))
          .toList();
      debugPrint('🖼️ Found ${imageAssets.length} album art images');

      // Tạo các đối tượng SongModel từ đường dẫn
      final List<SongModel> songs = [];
      for (var path in audioPaths) {
        final fileName = path.split('/').last.replaceAll('.mp3', '');
        
        // Parse artist và title từ fileName
        // Format: "Artist1, Artist2 - Song Title" hoặc "Artist - Song Title"
        final (artist, title) = _parseArtistAndTitle(fileName);
        
        // Tìm album art tương ứng
        final albumArt = _findAlbumArt(title, imageAssets);

        songs.add(SongModel(
          id: path,
          title: fileName,
          artist: artist,
          filePath: path,
          albumArt: albumArt,
        ));
      }

      _playlist = songs;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading songs: $e');
    }
  }

  /// Parse artist từ file name
  /// Format: "Artist1, Artist2 - Song Title"
  /// Returns: (artist, title)
  (String artist, String title) _parseArtistAndTitle(String fileName) {
    if (fileName.contains(' - ')) {
      final parts = fileName.split(' - ');
      final artist = parts[0].trim();
      final title = parts.sublist(1).join(' - ').trim();
      return (artist.isEmpty ? 'Unknown Artist' : artist, title);
    }
    return ('Unknown Artist', fileName);
  }

  /// Tìm album art dựa trên title
  String? _findAlbumArt(String title, List<String> imageAssets) {
    // Chuẩn hóa title để so sánh
    final normalizedTitle = title.toLowerCase().trim();
    debugPrint('🔍 Searching for album art for: "$normalizedTitle"');
    
    for (var imagePath in imageAssets) {
      final imageName = imagePath.split('/').last.replaceAll('.png', '').toLowerCase();
      
      // Exact match
      if (normalizedTitle == imageName) {
        debugPrint('✅ Found exact match: $imagePath');
        return imagePath;
      }
      
      // Partial match - title chứa imageName hoặc ngược lại
      if (normalizedTitle.contains(imageName) || imageName.contains(normalizedTitle)) {
        debugPrint('✅ Found partial match: $imagePath');
        return imagePath;
      }
      
      // Fuzzy match - loại bỏ các ký tự special
      final normalizedImageName = imageName.replaceAll(RegExp(r'[^\w\s]'), '');
      final normalizedTitleFuzzy = normalizedTitle.replaceAll(RegExp(r'[^\w\s]'), '');
      
      if (normalizedTitleFuzzy.contains(normalizedImageName) || normalizedImageName.contains(normalizedTitleFuzzy)) {
        debugPrint('✅ Found fuzzy match: $imagePath (image: "$normalizedImageName", title: "$normalizedTitleFuzzy")');
        return imagePath;
      }
    }
    
    debugPrint('❌ No album art found for: "$normalizedTitle"');
    return null;
  }

  /// Reload songs - gọi từ UI khi muốn refresh danh sách nhạc
  /// Cách dùng: context.read<AudioProvider>().reloadSongs()
  Future<void> reloadSongs() async {
    debugPrint('🔄 Reloading songs...');
    await loadSongs();
  }
  Future<void> setPlaylist(List<SongModel> songs, int startIndex) async {
  _playlist = songs;
  _currentIndex = startIndex;
  await _playSongAtIndex(_currentIndex);
  notifyListeners();
  }

  Future<void> _playSongAtIndex(int index) async {
  if (index < 0 || index >= _playlist.length) return;

  _currentIndex = index;
  final song = _playlist[index];

  // Kiểm tra xem đường dẫn có phải là asset hay không
  if (song.filePath.startsWith('lib/assets/')) {
    // Dùng setAssetPath() cho file asset đóng gói trong app
    await _audioService.loadAsset(song.filePath);
  } else {
    // Dùng setFilePath() cho file thực trên thiết bị
    await _audioService.loadAudio(song.filePath);
  }
  await _audioService.play();
  await _storageService.saveLastPlayed(song.id);

  notifyListeners();
  }

  Future<void> playPause() async {
  if (_audioService.isPlaying) {
  await _audioService.pause();
  } else {
  await _audioService.play();
  }
  notifyListeners();
  }

  Future<void> next() async {
  if (_isShuffleEnabled) {
  _currentIndex = _getRandomIndex();
  } else {
  _currentIndex = (_currentIndex + 1) % _playlist.length;
  }
  await _playSongAtIndex(_currentIndex);
  }

  Future<void> previous() async {
  if (_audioService.currentPosition.inSeconds > 3) {
  await _audioService.seek(Duration.zero);
  } else {
  if (_isShuffleEnabled) {
  _currentIndex = _getRandomIndex();
  } else {
  _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
  }
  await _playSongAtIndex(_currentIndex);
  }
  }

  Future<void> seek(Duration position) async {
  await _audioService.seek(position);
  }

  Future<void> toggleShuffle() async {
  _isShuffleEnabled = !_isShuffleEnabled;
  await _storageService.saveShuffleState(_isShuffleEnabled);
  notifyListeners();
  }

  Future<void> setShuffleEnabled(bool enabled) async {
  _isShuffleEnabled = enabled;
  await _storageService.saveShuffleState(_isShuffleEnabled);
  notifyListeners();
  }

  Future<void> toggleRepeat() async {
  switch (_loopMode) {
  case LoopMode.off:
  _loopMode = LoopMode.all;
  break;
  case LoopMode.all:
  _loopMode = LoopMode.one;
  break;
  case LoopMode.one:
  _loopMode = LoopMode.off;
  break;
  }

  await _audioService.setLoopMode(_loopMode);
  await _storageService.saveRepeatMode(_loopMode.index);
  notifyListeners();
  }

  Future<void> setRepeatOneEnabled(bool enabled) async {
  _loopMode = enabled ? LoopMode.one : LoopMode.off;
  await _audioService.setLoopMode(_loopMode);
  await _storageService.saveRepeatMode(_loopMode.index);
  notifyListeners();
  }

  Future<void> setVolume(double volume) async {
  _volume = volume;
  await _audioService.setVolume(volume);
  await _storageService.saveVolume(volume);
  notifyListeners();
  }

  Future<void> setAudioQuality(String quality) async {
  _audioQuality = quality;
  await _storageService.saveAudioQuality(quality);
  notifyListeners();
  }

  int _getRandomIndex() {
  final random = DateTime.now().millisecondsSinceEpoch % _playlist.length;
  return random;
  }

  @override
  void dispose() {
  _audioService.dispose();
  super.dispose();
  }
}
