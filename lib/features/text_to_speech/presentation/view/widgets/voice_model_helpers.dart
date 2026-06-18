import 'package:flutter/material.dart';

IconData voiceModelIcon(String code) =>
    code.startsWith('af') ? Icons.face_3 : Icons.face;

String voiceModelLabel(String code) {
  switch (code) {
    case 'af_heart':   return 'Heart 🌟';
    case 'af_nicole':  return 'Nicole ⚡';
    case 'am_eric':    return 'Eric 🎙️';
    case 'am_michael': return 'Michael 💼';
    default:           return 'Heart 🌟';
  }
}

String voiceModelDesc(String code) {
  switch (code) {
    case 'af_heart':   return 'Female — Warm, natural, and friendly';
    case 'af_nicole':  return 'Female — Clear, crisp, and professional';
    case 'am_eric':    return 'Male — Deep, expressive, and engaging';
    case 'am_michael': return 'Male — Formal, precise, and authoritative';
    default:           return '';
  }
}
