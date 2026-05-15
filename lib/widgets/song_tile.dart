import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/song_model.dart';
import '../providers/playlist_provider.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback? onTap;
  final VoidCallback? onRemoveFromPlaylist;
  final bool isInPlaylist;

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.onRemoveFromPlaylist,
    this.isInPlaylist = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildAlbumArt(colorScheme),
        title: Text(
          song.title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.artist,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Added: ${_formatDate(song.dateAdded)}',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
          onPressed: () => _showOptionsMenu(context),
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildAlbumArt(ColorScheme colorScheme) {
    if (song.albumArt != null && song.albumArt!.isNotEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: colorScheme.surfaceVariant,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            song.albumArt!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('❌ Failed to load image: ${song.albumArt!}');
              return _buildDefaultAvatar(colorScheme);
            },
          ),
        ),
      );
    } else {
      return _buildDefaultAvatar(colorScheme);
    }
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    final firstLetter =
        song.title.isNotEmpty ? song.title[0].toUpperCase() : '?';

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ];

    final color = colors[firstLetter.hashCode % colors.length];

    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🗑 Remove khỏi playlist
            if (isInPlaylist && onRemoveFromPlaylist != null)
              ListTile(
                leading: Icon(Icons.delete, color: colorScheme.error),
                title: Text(
                  'Remove from playlist',
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onRemoveFromPlaylist!();
                },
              ),

            /// ➕ Add to playlist
            if (!isInPlaylist)
              ListTile(
                leading: Icon(Icons.playlist_add, color: colorScheme.onSurface),
                title: Text(
                  'Add to playlist',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSelectPlaylistDialog(context);
                },
              ),

            ListTile(
              leading: Icon(Icons.share, color: colorScheme.onSurface),
              title: Text('Share', style: TextStyle(color: colorScheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _shareSong(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline, color: colorScheme.onSurface),
              title: Text('Song info', style: TextStyle(color: colorScheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _showSongInfo(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 🎯 Dialog chọn playlist
  void _showSelectPlaylistDialog(BuildContext context) {
    final playlistProvider = context.read<PlaylistProvider>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Select playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: playlistProvider.playlists.isEmpty
                ? const Text('No playlist available')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlistProvider.playlists.length,
                    itemBuilder: (_, index) {
                      final playlist =
                          playlistProvider.playlists[index];
                      return ListTile(
                        leading:
                            const Icon(Icons.queue_music),
                        title: Text(playlist.name),
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          await playlistProvider.addSongToPlaylist(
                            playlist.id,
                            song,
                          );

                          navigator.pop();

                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added "${song.title}" to "${playlist.name}"',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Share song using device share sheet
  Future<void> _shareSong(BuildContext context) async {
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

  /// Show detailed song information
  void _showSongInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Song Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Title', song.title, colorScheme),
              _infoRow('Artist', song.artist, colorScheme),
              if (song.album != null)
                _infoRow('Album', song.album!, colorScheme),
              if (song.duration != null)
                _infoRow(
                  'Duration',
                  _formatDuration(song.duration!),
                  colorScheme,
                ),
              _infoRow(
                'Added',
                '${song.dateAdded.day}/${song.dateAdded.month}/${song.dateAdded.year}',
                colorScheme,
              ),
              _infoRow('File Path', song.filePath, colorScheme),
              if (song.fileSize != null)
                _infoRow('File Size', _formatFileSize(song.fileSize!), colorScheme),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
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
