// lib/services/tts_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:http/http.dart' as http;
import '../constants/kokoro_vocab.dart';

class TtsService {
  static const String _phonemizeUrl =
      'https://cosmosbyme-ai-chatbot-app.hf.space/phonemize';

  OrtSession? _session;
  Float32List? _voiceStyle;
  bool _isInitialized = false;

  Future<void> initialize({String? voiceType}) async {
    if (_isInitialized) return;

    final ort = OnnxRuntime();

    // Load Kokoro ONNX model
    _session = await ort.createSessionFromAsset(
      'assets/models/model_quantized.onnx',
    );

    // Load voice style binary
    final voiceBytes = await rootBundle.load(
      'assets/voices/${voiceType ?? 'af_heart'}.bin',
    );
    _voiceStyle = voiceBytes.buffer.asFloat32List();

    _isInitialized = true;
  }

  Future<void> changeVoice(String voiceType) async {
  final voiceBytes = await rootBundle.load(
    'assets/voices/$voiceType.bin',
  );
  _voiceStyle = voiceBytes.buffer.asFloat32List();
}

  // Step 1: Text → IPA string via your HF Space
  Future<String> _phonemize(String text) async {
    final response = await http.post(
      Uri.parse(_phonemizeUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode != 200) {
      throw Exception('Phonemize failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (kDebugMode) {
      print('IPA: ${data['phonemes']}');
    }
    return data['phonemes'] as String;
  }

  // Step 2: IPA string → Kokoro token IDs
  List<int> _ipaToTokenIds(String ipa) {
    final List<int> ids = [];
    for (final char in ipa.runes) {
      final symbol = String.fromCharCode(char);
      final id = kokoroVocab[symbol];
      if (id != null) ids.add(id);
      // unknown chars are silently skipped
    }
    return ids;
  }

  // Step 3: Token IDs → raw audio via ONNX
  Future<Float32List> _synthesize(List<int> tokenIds) async {
    final paddedTokens = [0, ...tokenIds, 0];
    final seqLen = paddedTokens.length;
    final int64Tokens = Int64List.fromList(paddedTokens);

    final inputIds = await OrtValue.fromList(int64Tokens, [1, seqLen]);

    // Style vector: row index = original token count (before padding)
    final styleOffset = tokenIds.length * 256;
    final styleVector = _voiceStyle!.sublist(styleOffset, styleOffset + 256);
    final style = await OrtValue.fromList(styleVector.toList(), [1, 256]);

    final speed = await OrtValue.fromList([1.0], [1]);

    final outputs = await _session!.run({
      'input_ids': inputIds,
      'style': style,
      'speed': speed,
    });

    await inputIds.dispose();
    await style.dispose();
    await speed.dispose();

    // REPLACE with this
    final outputValue = outputs.values.first;
    final audioData = await outputValue.asFlattenedList();

    return Float32List.fromList(
      audioData.map((e) => (e as num).toDouble()).toList(),
    );
  }

  // Public method — full pipeline
  Future<Float32List> speak(String text) async {
    assert(_isInitialized, 'Call initialize() first');

    final ipa = await _phonemize(text);
    if (kDebugMode) {
      print('IPA: $ipa');
    } // useful for debugging

    final tokenIds = _ipaToTokenIds(ipa);
    if (kDebugMode) {
      print('Token IDs: $tokenIds'); // useful for debugging
    }

    if (tokenIds.isEmpty) {
      throw Exception('No valid tokens found for: $text');
    }

    return await _synthesize(tokenIds);
  }

  Future<void> dispose() async {
    await _session?.close();
    _isInitialized = false;
  }
}
