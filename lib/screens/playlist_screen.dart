import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../screens/playlist_detail_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlaylistProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Playlist của tôi',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
        onPressed: () => _showCreatePlaylistDialog(context),
      ),
      body: playlistProvider.playlists.isEmpty
          ? Center(
              child: Text(
                'Chưa có playlist nào',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: playlistProvider.playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlistProvider.playlists[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.queue_music, color: colorScheme.primary),
                    title: Text(playlist.name),
                    subtitle:
                        Text('${playlist.songIds.length} bài hát'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaylistDetailScreen(
                            playlistId: playlist.id,
                          ),
                        ),
                      );
                    },
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'rename') {
                          _showRenameDialog(context, playlist.id, playlist.name);
                        } else if (value == 'delete') {
                          await playlistProvider.deletePlaylist(playlist.id);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'rename',
                          child: Text('Đổi tên'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Xoá',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tạo playlist mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nhập tên playlist',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final navigator = Navigator.of(context);
              final playlistProvider = context.read<PlaylistProvider>();
              await playlistProvider.createPlaylist(controller.text.trim());
              navigator.pop();
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
      BuildContext context, String id, String oldName) {
    final controller = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đổi tên playlist'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final navigator = Navigator.of(context);
              final playlistProvider = context.read<PlaylistProvider>();
              await playlistProvider.renamePlaylist(id, controller.text.trim());
              navigator.pop();
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
