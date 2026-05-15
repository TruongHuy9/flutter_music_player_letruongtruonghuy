import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'providers/audio_provider.dart';
import 'providers/playlist_provider.dart';
import 'providers/theme_provider.dart';
import 'services/audio_player_service.dart';
import 'services/storage_service.dart';
import 'services/app_lifecycle_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  debugPrint('🚀 ===== APP STARTUP BEGIN =====');
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  debugPrint('🔧 SharedPreferences initialized');
  
  // Load theme preference with fallback
  final initialDarkMode = prefs.getBool(ThemeProvider.darkModeKey) ?? false;
  debugPrint('🎨 Main: Loaded theme preference - isDarkMode=$initialDarkMode');
  
  // Initialize StorageService singleton
  final storageService = StorageService();
  await storageService.init();
  
  // Debug: Print all loaded data on startup
  await storageService.debugPrintAllData();
  
  debugPrint('🚀 ===== APP STARTUP COMPLETE =====');
  
  runApp(MyApp(initialDarkMode: initialDarkMode, storageService: storageService));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  final StorageService storageService;

  const MyApp({
    super.key,
    required this.initialDarkMode,
    required this.storageService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifecycleManager _lifecycleManager;

  @override
  void initState() {
    super.initState();
    // Initialize app lifecycle manager after providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lifecycleManager = AppLifecycleManager(
        themeProvider: context.read<ThemeProvider>(),
        playlistProvider: context.read<PlaylistProvider>(),
        audioProvider: context.read<AudioProvider>(),
        storageService: context.read<StorageService>(),
      );
      _lifecycleManager.init();
    });
  }

  @override
  void dispose() {
    _lifecycleManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: widget.storageService),
        Provider<AudioPlayerService>(
          create: (_) => AudioPlayerService(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(initialDarkMode: widget.initialDarkMode),
        ),
        ChangeNotifierProvider<AudioProvider>(
          create: (context) => AudioProvider(
            context.read<AudioPlayerService>(),
            context.read<StorageService>(),
          )..loadSongs(),
        ),
        ChangeNotifierProxyProvider<AudioProvider, PlaylistProvider>(
          create: (context) => PlaylistProvider(
            context.read<StorageService>(),
          )..loadPlaylists(),
          update: (context, audioProvider, playlistProvider) {
            playlistProvider!.setAllSongs(audioProvider.playlist);
            return playlistProvider;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Music App',
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
