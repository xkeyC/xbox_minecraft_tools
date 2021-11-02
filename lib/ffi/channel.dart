import 'dart:ffi';

import 'package:xbox_minecraft_tools/ffi/types.dart';

import 'lib-core.dart';

class CoreLibChannel {
  static final _coreLib = NativeLibrary(DynamicLibrary.open("libcore.so"));

  /// Test CORE
  static String Ping() {
    try {
      final result = _coreLib.Ping(CString.formString("PONG"));
      if (result.toDartString() == "PONG") {
        return "ok";
      }
      return "FFI Result:$result";
    } catch (e) {
      return "[ffi]{Ping} ERROR:$e";
    }
  }
}
