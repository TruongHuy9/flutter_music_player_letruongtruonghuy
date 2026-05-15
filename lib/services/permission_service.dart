import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PermissionService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> requestMusicPermission() async {
    final hasPermission = await _audioQuery.permissionsStatus();
    if (hasPermission) return true;

    final granted = await _audioQuery.permissionsRequest();
    if (granted) return true;

    if (await Permission.audio.isPermanentlyDenied ||
        await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }
}
