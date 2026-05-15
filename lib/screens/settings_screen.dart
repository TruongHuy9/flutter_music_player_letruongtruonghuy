import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context, 'Giao diện'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Chế độ tối'),
            subtitle: const Text('Bật/tắt giao diện tối'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.setDarkMode(value);
            },
          ),
          _buildSectionTitle(context, 'Âm thanh'),
          ListTile(
            leading: const Icon(Icons.volume_up_outlined),
            title: const Text('Âm lượng nhạc'),
            subtitle: Slider(
              value: audioProvider.volume,
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(audioProvider.volume * 100).round()}%',
              onChanged: audioProvider.setVolume,
            ),
            trailing: Text('${(audioProvider.volume * 100).round()}%'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.shuffle),
            title: const Text('Phát ngẫu nhiên'),
            subtitle: const Text('Trộn bài hát khi chuyển bài'),
            value: audioProvider.isShuffleEnabled,
            onChanged: audioProvider.setShuffleEnabled,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.repeat_one),
            title: const Text('Lặp lại bài hát'),
            subtitle: const Text('Tự động phát lại bài đang nghe'),
            value: audioProvider.loopMode == LoopMode.one,
            onChanged: audioProvider.setRepeatOneEnabled,
          ),
          ListTile(
            leading: const Icon(Icons.high_quality_outlined),
            title: const Text('Chất lượng âm thanh'),
            subtitle: const Text('Lưu lựa chọn chất lượng phát'),
            trailing: DropdownButton<String>(
              value: audioProvider.audioQuality,
              items: const [
                DropdownMenuItem(value: 'Thấp', child: Text('Thấp')),
                DropdownMenuItem(
                  value: 'Trung bình',
                  child: Text('Trung bình'),
                ),
                DropdownMenuItem(value: 'Cao', child: Text('Cao')),
              ],
              onChanged: (value) {
                if (value == null) return;
                audioProvider.setAudioQuality(value);
              },
            ),
          ),
          _buildSectionTitle(context, 'Thông tin'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Phiên bản ứng dụng'),
            subtitle: Text('1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.developer_mode),
            title: Text('Nhà phát triển'),
            subtitle: Text('Lê Trương Trường Huy'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Text(
              'Các cài đặt âm lượng, phát ngẫu nhiên, lặp lại và chất lượng sẽ được lưu lại cho lần mở app sau.',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
