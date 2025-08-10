import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() {
    return _instance;
  }
  SettingsService._internal();

  SharedPreferences? _prefs;
  final StreamController<String> _changeController = StreamController<String>.broadcast();

  Stream<String> get onChanged => _changeController.stream;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (getBool('wasTheAppRanAlready') == null) {
      await setBool('test1', false);
      await setBool('test2', true);
      await setBool('test3', true);
      await setBool('test4', false);
      await setDouble('appVolume', 1);
      await setBool('equalizerToggle', false);
      await setBool('skipToStart', false);
      await setBool('backgroundPlayback', true);
      await setBool('progressiveBlur', false);
      // New music app settings defaults
      await setBool('gaplessPlayback', true);
      await setBool('crossfadeEnabled', false);
      await setDouble('crossfadeSeconds', 5.0);
      await setBool('volumeNormalization', false);
      await setString('streamingQualityWifi', 'high');
      await setString('streamingQualityCellular', 'medium');
      await setString('downloadQuality', 'high');
      await setBool('explicitContentFilter', false);
      await setBool('autoplayRelated', true);
      await setBool('showNotificationControls', true);
      await setBool('lockScreenControls', true);
      await setBool('showLyrics', true);
      await setBool('hapticFeedback', true);
      await setString('themeMode', 'system'); // system|dark|light
      await setString('replayGainMode', 'album'); // off|track|album
      await setBool('wasTheAppRanAlready', true);
    }
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
  
  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    final ok = await _prefs?.setBool(key, value);
    if (ok == true) _changeController.add(key);
  }

  Future<void> setDouble(String key, double value) async {
    final ok = await _prefs?.setDouble(key, value);
    if (ok == true) _changeController.add(key);
  }

  Future<void> setString(String key, String value) async {
    final ok = await _prefs?.setString(key, value);
    if (ok == true) _changeController.add(key);
  }

  // (Optional) could add a dispose if ever needed:
  // void dispose() => _changeController.close();
}