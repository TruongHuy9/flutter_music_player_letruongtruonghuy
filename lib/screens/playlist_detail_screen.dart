import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
  });

  Future<void> _exportPdf(
    BuildContext context,
    String playlistName,
    List<SongModel> songs,
  ) async {
    if (songs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playlist trống')),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              playlistName,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
            ...songs.asMap().entries.map((entry) {
              final index = entry.key;
              final song = entry.value;
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Text(
                  '${index + 1}. ${song.title} - ${song.artist}',
                ),
              );
            }),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlaylistProvider>();
    final audioProvider = context.watch<AudioProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final playlist = playlistProvider.getById(playlistId);

    if (playlist == null) {
      return Scaffold(
        body: Center(child: Text('Không tìm thấy playlist', style: TextStyle(color: colorScheme.onSurface))),
      );
    }

    final songs =
        playlistProvider.getSongsOfPlaylist(playlistId);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: BackButton(color: colorScheme.onSurface),
        title: Text(
          playlist.name,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: colorScheme.onSurface),
            tooltip: 'Xuất PDF',
            onPressed: () => _exportPdf(
              context,
              playlist.name,
              songs,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: songs.isEmpty
                ? Center(
                    child: Text(
                      'Playlist chưa có bài hát',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (_, index) {
                      final song = songs[index];
                      return SongTile(
                        song: song,
                        isInPlaylist: true,
                        onTap: () {
                          audioProvider.setPlaylist(songs, index);
                        },
                        onRemoveFromPlaylist: () async {
                          await playlistProvider.removeSongFromPlaylist(
                            playlistId,
                            song.id,
                          );
                        },
                      );
                    },
                  ),
          ),
          if (audioProvider.currentSong != null)
            const MiniPlayer(),
        ],
      ),
    );
  }
}
