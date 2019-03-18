package io.flutter.plugins.wearable_data_layer;

import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.wearable.MessageClient;
import com.google.android.gms.wearable.MessageEvent;
import com.google.android.gms.wearable.Wearable;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugins.wearable_data_layer.Sender;

/** WearableDataLayerPlugin */
public class WearableDataLayerPlugin implements MethodCallHandler, MessageClient.OnMessageReceivedListener {

  private static final String TAG = "WearableDataLayerPlugin";
  private static final String CHANNEL_NAME = "wearable_data_layer";
  private static final String default_path = "/flutter_wearable_datalayer";
  private final Registrar registrar;
  private final MethodChannel channel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    WearableDataLayerPlugin instance = new WearableDataLayerPlugin(registrar, channel);
    channel.setMethodCallHandler(instance);
  }

  private WearableDataLayerPlugin(Registrar registrar, MethodChannel channel) {
    this.registrar = registrar;
    this.channel = channel;
    Wearable.getMessageClient(this.registrar.activity()).addListener(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Map<String, Object> arguments = (Map) call.arguments;
    switch (call.method) {
    case "getPlatformVersion":
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      break;
    case "sendDefaultPath":
      final String message = (String) arguments.get("message");
      new Sender(default_path, message, this.registrar, result).start();
      break;
    case "sendCustomPath":
      final String custom_message = (String) arguments.get("message");
      final String custom_path = (String) arguments.get("path");
      new Sender(custom_path, custom_message, this.registrar, result).start();
      break;
    default:
      result.notImplemented();
      break;
    }
  }

  @Override
  public void onMessageReceived(MessageEvent event) {
      HashMap<String, Object> data = new HashMap();
      data.put("from", event.getRequestId());
      data.put("path", event.getPath());
      data.put("value", new String(event.getData()));
      channel.invokeMethod("receivedMessage", data);
  }
}
