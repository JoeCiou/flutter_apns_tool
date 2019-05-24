import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_apns_tool/flutter_apns_tool.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _deviceTokenString = 'Unknown';

  @override
  void initState() {
    super.initState();
    openNotifications();
  }

  void openNotifications() async {
    await FlutterApnsTool.requestNotificationsPermission(sound: true, alert: true, badge: true);
    dynamic deviceToken = await FlutterApnsTool.getDeviceToken();
    String deviceTokenString = convertRawDeviceToken(deviceToken);

    setState(() {
      _deviceTokenString = deviceTokenString;
    });
  }

  String convertRawDeviceToken(Uint8List deviceToken) {
    String s = '';
    for (int byte in deviceToken) {
      String byteString = byte.toRadixString(16);
      if (byteString.length == 1) byteString = '0' + byteString;
      s += byteString;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_deviceTokenString\n'),
        ),
      ),
    );
  }
}
