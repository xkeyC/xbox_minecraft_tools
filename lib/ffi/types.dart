import 'dart:convert';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

extension CString on ffi.Pointer<ffi.Int8> {
  String toDartString() {
    final len = _length(this);
    List<int> units = [];
    for (int i = 0; i < len; ++i) {
      units.add(elementAt(i).value);
    }
    return Utf8Decoder().convert(units);
  }

  static ffi.Pointer<ffi.Int8> formString(String str) {
    return str.toNativeUtf8().cast<ffi.Int8>();
  }

  static int _length(ffi.Pointer<ffi.Int8> codeUnits) {
    var length = 0;
    while (codeUnits[length] != 0) {
      length++;
    }
    return length;
  }
}