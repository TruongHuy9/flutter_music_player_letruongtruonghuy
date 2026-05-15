import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';
import '../screens/settings_screen.dart';
//import '../screens/search_screen.dart';
import '../screens/playlist_screen.dart';

enum SortOption { title, artist, album, dateAdded }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SortOption _sortOption = SortOption.title;
  String _searchQuery = '';
  String? _filterArtist;
  String? _filterAlbum;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _checkPermissions() async {
    // Xin quyền truy cập Audio (Android 13+) và Storage (Android cũ)
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.storage,
    ].request();

    if (statuses[Permission.audio]!.isGranted || statuses[Permission.storage]!.isGranted) {
      // Nếu đã được cấp quyền, bảo AudioProvider quét nhạc từ máy
      if (mounted) {
        context.read<AudioProvider>().loadSongs();
      }
    } else {
      // Nếu bị từ chối, thông báo cho người dùng
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng cấp quyền để ứng dụng đọc được nhạc!")),
        );
      }
    }
  }
  // --------------------------------

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();
    final songs = audioProvider.playlist;
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final filteredSongs = _getFilteredAndSortedSongs(songs);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          debugPrint('💾 Saving all data on app close...');
          await context.read<PlaylistProvider>().saveAllData();
          await context.read<ThemeProvider>().savePersistence();
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, songs, colorScheme),
              _buildFilterBar(context, songs, colorScheme),
              Expanded(
                child: filteredSongs.isEmpty
                    ? _buildNoSongs(colorScheme)
                    : _buildSongList(filteredSongs),
              ),
              Consumer<AudioProvider>(
                builder: (context, provider, child) {
                  if (provider.currentSong == null) return const SizedBox.shrink();
                  return const MiniPlayer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, List<SongModel> songs, ColorScheme colorScheme) {
    final artists = _getUniqueArtists(songs).toList()..sort();
    final albums = _getUniqueAlbums(songs).toList()..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Sort dropdown
            Chip(
              label: Text(
                'Sort: ${_sortOption.name.toUpperCase()}',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              backgroundColor: colorScheme.surface,
              onDeleted: () {
                showMenu<SortOption>(
                  context: context,
                  position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                  items: SortOption.values.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option.name.toUpperCase()),
                    );
                  }).toList(),
                ).then((value) {
                  if (value != null) {
                    setState(() => _sortOption = value);
                  }
                });
              },
            ),
            const SizedBox(width: 8),
            
            // Artist filter
            if (artists.isNotEmpty)
              Chip(
                label: Text(
                  _filterArtist ?? 'All Artists',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                backgroundColor: colorScheme.surface,
                deleteIcon: _filterArtist != null ? null : Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant),
                onDeleted: () {
                  showMenu<String?>(
                    context: context,
                    position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                    items: [
                      const PopupMenuItem(
                        value: null,
                        child: Text('All Artists'),
                      ),
                      ...artists.map((artist) {
                        return PopupMenuItem(
                          value: artist,
                          child: Text(artist),
                        );
                      }).toList(),
                    ],
                  ).then((value) {
                    setState(() => _filterArtist = value);
                  });
                },
              ),
            const SizedBox(width: 8),

            // Album filter
            if (albums.isNotEmpty)
              Chip(
                label: Text(
                  _filterAlbum ?? 'All Albums',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                backgroundColor: colorScheme.surface,
                deleteIcon: _filterAlbum != null ? null : Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant),
                onDeleted: () {
                  showMenu<String?>(
                    context: context,
                    position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                    items: [
                      const PopupMenuItem(
                        value: null,
                        child: Text('All Albums'),
                      ),
                      ...albums.map((album) {
                        return PopupMenuItem(
                          value: album,
                          child: Text(album),
                        );
                      }).toList(),
                    ],
                  ).then((value) {
                    setState(() => _filterAlbum = value);
                  });
                },
              ),
            
            // Clear filters button
            if (_filterArtist != null || _filterAlbum != null || _searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Chip(
                  label: const Text('Clear'),
                  backgroundColor: colorScheme.errorContainer,
                  labelStyle: TextStyle(color: colorScheme.error),
                  onDeleted: () {
                    setState(() {
                      _searchQuery = '';
                      _filterArtist = null;
                      _filterAlbum = null;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, List<SongModel> songs, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Music',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.refresh, color: colorScheme.onSurface),
                tooltip: 'Reload songs',
                onPressed: () async {
                  await context.read<AudioProvider>().reloadSongs();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Songs reloaded'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: colorScheme.onSurface),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Search Songs'),
                      content: TextField(
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search by title or artist...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() => _searchQuery = '');
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.queue_music, color: colorScheme.onSurface),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlaylistScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: colorScheme.onSurface),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSongList(List<SongModel> songs) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongTile(
          song: song,
          onTap: () {
            context.read<AudioProvider>().setPlaylist(
                  songs,
                  index,
                );
          },
        );
      },
    );
  }

  Widget _buildNoSongs(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 80, color: colorScheme.outline),
          const SizedBox(height: 20),
          Text(
            'No Music Found',
            style: TextStyle(color: colorScheme.onSurface, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Quét nhạc từ thiết bị...',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Filter and sort songs
  List<SongModel> _getFilteredAndSortedSongs(List<SongModel> songs) {
    var filtered = songs.where((song) {
      // Apply search filter
      final matchSearch = _searchQuery.isEmpty ||
          song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song.artist.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Apply artist filter
      final matchArtist = _filterArtist == null || 
          song.artist.contains(_filterArtist!);
      
      // Apply album filter
      final matchAlbum = _filterAlbum == null || 
          (song.album?.contains(_filterAlbum!) ?? false);
      
      return matchSearch && matchArtist && matchAlbum;
    }).toList();

    // Apply sorting
    switch (_sortOption) {
      case SortOption.title:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.artist:
        filtered.sort((a, b) => a.artist.compareTo(b.artist));
        break;
      case SortOption.album:
        filtered.sort((a, b) => (a.album ?? '').compareTo(b.album ?? ''));
        break;
      case SortOption.dateAdded:
        // Assume later songs are added later (reverse order)
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return filtered;
  }

  /// Get unique artists from songs
  Set<String> _getUniqueArtists(List<SongModel> songs) {
    return songs.map((s) => s.artist).toSet();
  }

  /// Get unique albums from songs
  Set<String> _getUniqueAlbums(List<SongModel> songs) {
    return songs.where((s) => s.album != null && s.album!.isNotEmpty)
        .map((s) => s.album!)
        .toSet();
  }
}