import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:xbox_minecraft_tools/ffi/types.dart';

import 'lib-core.dart';

class CoreLibChannel {
  static final _coreLib = NativeLibrary(DynamicLibrary.open("libcore.so"));

  /// Test CORE
  static String Ping() {
    try {
      final result = _coreLib.Ping(CChar.formString("PONG"));
      if (result.toDartString() == "PONG") {
        return "ok";
      }
      return "FFI Result:$result";
    } catch (e) {
      return "[ffi]{Ping} ERROR:$e";
    }
  }

  static Future<String> StartUDPProxy(String host, String port) async {
    return compute(_StartUDPProxy, {"host": host, "port": port});
  }

  static Future<String> StopUDPProxy() async {
    return compute(_StopUDPProxy,"");
  }

  static String _StartUDPProxy(Map data) {
    try {
      final result = _coreLib.StartUDPProxy(
          CChar.formString(data["host"]), CChar.formString(data["port"]));
      return result.toDartString();
    } catch (e) {
      return "[ffi]{_StartUDPProxy} ERROR:$e";
    }
  }

  static String _StopUDPProxy(void _) {
    try {
      _coreLib.StopUDPProxy();
      return "ok";
    } catch (e) {
      return "[ffi]{_StopUDPProxy} ERROR:$e";
    }
  }
}
