import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wearable_data_layer/wearable_data_layer.dart';

final MethodChannel channel = MethodChannel("wearable_data_layer");

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> _message = Future<String>.value('');
  @override
  void initState() {
    super.initState();
  }

  void assignFuture(Function func) {
    setState(() {
      _message = func();
    });
  }

  Future<String> sendMessage() async {
    final bool response = await WearableDataLayer.sendDefaultPath(
      'Saludos desde wearable',
    );
    return '''path:
    /flutter_wearable_datalayer: 
    response: $response''';
  }

  Future<String> sendCustomPathMessage() async {
    final bool response = await WearableDataLayer.sendCustomPath(
      'test',
      'Saludos desde wearable custom',
    );
    return '''path:
    /test: 
    response: $response''';
  }

  void receivedMessage(dynamic data) {
    print('data received on mobile: $data');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: WearableReceiverWidget(
            builder: (context, data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Mensaje: ${data != null ? data.toString() : ''}',
                  ),
                  MaterialButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text('Send Default'),
                    onPressed: () => assignFuture(this.sendMessage),
                  ),
                  MaterialButton(
                    color: Colors.indigo,
                    textColor: Colors.white,
                    child: Text('Send Custom'),
                    onPressed: () => assignFuture(this.sendCustomPathMessage),
                  ),
                  FutureBuilder<String>(
                      future: _message,
                      builder: (_, AsyncSnapshot<String> snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        );
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
