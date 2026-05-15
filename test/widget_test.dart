
//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter_music_player/main.dart';
import 'package:flutter_music_player/services/audio_player_service.dart';

void main() {
  group('AudioPlayerService Tests', () {
    late AudioPlayerService service;

    setUp(() {
      service = AudioPlayerService();
    });

    tearDown(() {
      service.dispose();
    });

    test('Initial state is not playing', () {
      expect(service.isPlaying, false);
    });

    test('Load audio file successfully', () async {
      await service.loadAudio('assets/audio/sample.mp3');

      expect(service.currentDuration, isNotNull);
    });
  });
}
