//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <firebase_app_check/firebase_app_check_plugin_c_api.h>
#include <firebase_auth/firebase_auth_plugin_c_api.h>
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <flutter_onnxruntime/flutter_onnxruntime_plugin.h>
#include <flutter_tts/flutter_tts_plugin.h>
#include <speech_to_text_windows/speech_to_text_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FirebaseAppCheckPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseAppCheckPluginCApi"));
  FirebaseAuthPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseAuthPluginCApi"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  FlutterOnnxruntimePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterOnnxruntimePlugin"));
  FlutterTtsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTtsPlugin"));
  SpeechToTextWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SpeechToTextWindows"));
}
