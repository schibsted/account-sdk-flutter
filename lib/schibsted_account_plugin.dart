import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'schibsted_account.dart';

class SchibstedAccountPlugin {
  static const MethodChannel _callbackMethodChannel = const MethodChannel('schibsted_account/callbacks');
  static const EventChannel _loginEventsChannel = const EventChannel('schibsted_account/events', const JSONMethodCodec());

  static get login async {
    await _callbackMethodChannel.invokeMethod('login');
  }

  static get logout async {
    await _callbackMethodChannel.invokeMethod('logout');
  }

  static Stream<dynamic> get loginEvents {
    return _loginEventsChannel.receiveBroadcastStream().map((dynamic event) {
      return SchibstedAccountEvent.fromJson(json.decode(event));
    });
  }
}
