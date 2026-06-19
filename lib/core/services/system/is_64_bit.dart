import 'package:device_info_plus/device_info_plus.dart';

Future<bool> is64bit() async {
  try {
    // Read the device's supported ABIs
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    
    // supportedAbis lists what the device supports
    // arm64-v8a = 64-bit, armeabi-v7a = 32-bit
    return androidInfo.supportedAbis.contains('arm64-v8a');
  } catch (e) {
    return false; // assume not supported if check fails
  }
}