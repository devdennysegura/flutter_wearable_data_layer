package io.flutter.plugins.wearable_data_layer;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WearableDataLayerPlugin */
public class WearableDataLayerPlugin implements MethodCallHandler {

  private final Registrar registrar;
  private final MethodChannel channel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final String CHANNEL_NAME = "plugins.flutter.io/wearable_data_layer";
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    WearableDataLayerPlugin instance = new WearableDataLayerPlugin(registrar, channel);
    channel.setMethodCallHandler(instance);
  }

  private WearableDataLayerPlugin(Registrar registrar, MethodChannel channel) {
    this.registrar = registrar;
    this.channel = channel;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
