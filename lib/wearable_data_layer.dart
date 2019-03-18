import 'dart:async';

import 'package:flutter/services.dart';

class WearableDataLayer {
  static const MethodChannel _channel =
      const MethodChannel('wearable_data_layer');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
