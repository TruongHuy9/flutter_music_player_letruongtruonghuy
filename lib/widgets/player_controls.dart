import 'package:flutter/material.dart';
import '../providers/audio_provider.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControls extends StatelessWidget {
  final AudioProvider provider;

  const PlayerControls({
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: provider.isShuffleEnabled
                    ? const Color(0xFF1DB954)
                    : colorScheme.onSurfaceVariant,
              ),
              onPressed: provider.toggleShuffle,
            ),
            const SizedBox(width: 40),
            _buildRepeatButton(colorScheme),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: colorScheme.onSurface,
                size: 40,
              ),
              onPressed: provider.previous,
            ),

            StreamBuilder<bool>(
              stream: provider.playingStream,
              initialData: provider.isPlaying,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1DB954),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: provider.playPause,
                  ),
                );
              },
            ),

            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: colorScheme.onSurface,
                size: 40,
              ),
              onPressed: provider.next,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRepeatButton(ColorScheme colorScheme) {
    IconData icon;
    Color color;

    switch (provider.loopMode) {
      case LoopMode.off:
        icon = Icons.repeat;
        color = colorScheme.onSurfaceVariant;
        break;
      case LoopMode.all:
        icon = Icons.repeat;
        color = const Color(0xFF1DB954);
        break;
      case LoopMode.one:
        icon = Icons.repeat_one;
        color = const Color(0xFF1DB954);
        break;
    }

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: provider.toggleRepeat,
    );
  }
}
