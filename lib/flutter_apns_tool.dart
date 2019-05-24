import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class FlutterApnsTool {
  static const MethodChannel _channel = const MethodChannel('flutter_apns_tool');

  static Future<dynamic> getDeviceToken() {
    if (Platform.isIOS) {
      return _channel.invokeMethod('getDeviceToken');
    } else {
      return Future<String>.value("The function is only support iOS");
    }
  }

  static Future<dynamic> requestNotificationsPermission({bool sound, bool badge, bool alert}) {
    if (Platform.isIOS) {
      return _channel.invokeMethod('requestNotificationsPermission', {
        'sound': sound,
        'badge': badge,
        'alert': alert
      });
    } else {
      return Future<String>.value("The function is only support iOS");
    }
  }
}
