import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_data_layer/wearable_data_layer.dart';

void main() {
  const MethodChannel channel = MethodChannel('wearable_data_layer');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('send default message', () async {
    final bool response = await WearableDataLayer.sendDefaultPath(
      'test from wearable',
    );
    // compare to false because, its not running over wearable
    expect(response, isFalse);
  });
}
