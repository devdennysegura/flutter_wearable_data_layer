package io.flutter.plugins.wearable_data_layer;

import android.util.Log;

import android.content.Intent;
import com.google.android.gms.wearable.MessageEvent;
import android.support.v4.content.LocalBroadcastManager;
import com.google.android.gms.wearable.WearableListenerService;

public class MessageService extends WearableListenerService {
    private static final String TAG = "MessageService";
    @Override
    public void onMessageReceived(MessageEvent messageEvent) {
        if (messageEvent.getPath().equals("/flutter_wearable_datalayer")) {
            final String message = new String(messageEvent.getData());
            Intent messageIntent = new Intent();
            messageIntent.setAction(Intent.ACTION_SEND);
            messageIntent.putExtra("message", message);
            LocalBroadcastManager.getInstance(this).sendBroadcast(messageIntent);
        }
        else {
            super.onMessageReceived(messageEvent);
        }
    }

}