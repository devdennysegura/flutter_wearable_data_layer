import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

const MethodChannel channel = const MethodChannel('wearable_data_layer');

class WearableDataLayer {
  static Future<bool> sendDefaultPath(String data) async {
    final bool sended = (await channel.invokeMethod(
          'sendDefaultPath',
          {'message': data},
        ))
            .toString()
            .toLowerCase() ==
        'true';
    return sended;
  }

  static Future<bool> sendCustomPath(String path, String data) async {
    final bool sended = (await channel.invokeMethod(
          'sendCustomPath',
          {
            'path': path,
            'message': data,
          },
        ))
            .toString()
            .toLowerCase() ==
        'true';
    return sended;
  }
}

typedef Widget WearableReceiverBuilder(
  BuildContext context,
  dynamic receivedData,
);

class WearableReceiverWidget extends StatefulWidget {
  final WearableReceiverBuilder builder;
  final Function onReceived;

  WearableReceiverWidget({Key key, @required this.builder, this.onReceived})
      : assert(builder != null),
        super(key: key);

  @override
  createState() => _WearableReceiverWidgetState();
}

class _WearableReceiverWidgetState extends State<WearableReceiverWidget> {
  var receivedMessage;

  @override
  initState() {
    super.initState();
    channel.setMethodCallHandler((call) {
      if (call.method == 'receivedMessage') {
        setState(() => receivedMessage = call.arguments);
        if (widget.onReceived != null) widget.onReceived(call.arguments);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        receivedMessage,
      );
}
