import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../widgets/song_tile.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class SearchScreen extends StatefulWidget {
  final List<SongModel> songs;

  const SearchScreen({super.key, required this.songs});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<SongModel> _results = [];

  void _search(String query) {
    setState(() {
      _results = widget.songs
          .where((song) =>
              song.title.toLowerCase().contains(query.toLowerCase()) ||
              song.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Search songs...',
              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            ),
            onChanged: _search,
          ),
        ),
      ),
      body: _results.isEmpty
          ? Center(
              child: Text(
                'No results',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 18),
              ),
            )
          : ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) => Divider(
                color: colorScheme.outline,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final song = _results[index];
                return GestureDetector(
                  onTap: () {

                  },
                  child: SongTile(
                    song: song,
                    onTap: () {
                      context.read<AudioProvider>().setPlaylist(_results, index);
                    },
                  ),
                );
              },
            ),
    );
  }
}
