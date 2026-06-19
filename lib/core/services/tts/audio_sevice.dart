// lib/services/audio_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playPcm(Float32List samples, {int sampleRate = 24000}) async {
    final wavPath = await _saveAsWav(samples, sampleRate: sampleRate);
    await _player.setFilePath(wavPath);
    await _player.play();
  }

  Future<String> _saveAsWav(Float32List samples, {int sampleRate = 24000}) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/kokoro_output.wav');

    final numSamples = samples.length;
    final byteData = ByteData(44 + numSamples * 2);

    // WAV header
    _writeString(byteData, 0, 'RIFF');
    byteData.setUint32(4, 36 + numSamples * 2, Endian.little);
    _writeString(byteData, 8, 'WAVE');
    _writeString(byteData, 12, 'fmt ');
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);   // PCM
    byteData.setUint16(22, 1, Endian.little);   // mono
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * 2, Endian.little);
    byteData.setUint16(32, 2, Endian.little);
    byteData.setUint16(34, 16, Endian.little);
    _writeString(byteData, 36, 'data');
    byteData.setUint32(40, numSamples * 2, Endian.little);

    // Convert float32 → int16
    for (int i = 0; i < numSamples; i++) {
      final clamped = samples[i].clamp(-1.0, 1.0);
      final int16 = (clamped * 32767).round();
      byteData.setInt16(44 + i * 2, int16, Endian.little);
    }

    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  void _writeString(ByteData data, int offset, String s) {
    for (int i = 0; i < s.length; i++) {
      data.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}