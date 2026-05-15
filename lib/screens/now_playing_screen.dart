import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';
import '../models/playback_state_model.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;

          if (song == null) {
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: Center(
                child: Text(
                  'No song playing',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            );
          }

          return Stack(
            children: [
              // Background image với blur effect
              if (song.albumArt != null)
                Positioned.fill(
                  child: Image.asset(
                    song.albumArt!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    color: colorScheme.surface,
                  ),
                ),
              
              // Semi-transparent overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

              // Content
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAlbumArt(song),
                            const SizedBox(height: 40),
                            _buildSongInfo(song, colorScheme),
                            const SizedBox(height: 40),
                            StreamBuilder<PlaybackUiState>(
                              stream: provider.playbackStateStream,
                              initialData: provider.currentPlaybackState,
                              builder: (context, snapshot) {
                                final state = snapshot.data;
                                return ProgressBar(
                                  position: state?.position ?? Duration.zero,
                                  duration: state?.duration ?? Duration.zero,
                                  onSeek: (position) {
                                    provider.seek(position);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            PlayerControls(provider: provider),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Now Playing',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showNowPlayingMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(SongModel song) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: song.albumArt != null
            ? Image.asset(song.albumArt!, fit: BoxFit.cover)
            : Container(
                color: Colors.grey[800],
                child: const Icon(Icons.music_note, size: 100, color: Colors.white54),
              ),
      ),
    );
  }

  Widget _buildSongInfo(SongModel song, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          song.artist,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Show menu for now playing screen
  void _showNowPlayingMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final provider = context.read<AudioProvider>();
        final song = provider.currentSong;
        if (song == null) return const SizedBox.shrink();

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text(
                  'Share Song',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareSong(context, song);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'Song Information',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSongInfo(context, song);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Share song
  Future<void> _shareSong(BuildContext context, SongModel song) async {
    final shareText = '''
🎵 Now playing: ${song.title}
🎤 Artist: ${song.artist}
📱 Via Music Player App

Check it out!
''';

    try {
      await Share.share(shareText);
    } catch (e) {
      debugPrint('Error sharing song: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }

  /// Show song info dialog
  void _showSongInfo(BuildContext context, SongModel song) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Song Information',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Title', song.title),
              _infoRow('Artist', song.artist),
              if (song.album != null) _infoRow('Album', song.album!),
              if (song.duration != null)
                _infoRow('Duration', _formatDuration(song.duration!)),
              _infoRow(
                'Added',
                '${song.dateAdded.day}/${song.dateAdded.month}/${song.dateAdded.year}',
              ),
              _infoRow('File Path', song.filePath),
              if (song.fileSize != null)
                _infoRow('File Size', _formatFileSize(song.fileSize!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
