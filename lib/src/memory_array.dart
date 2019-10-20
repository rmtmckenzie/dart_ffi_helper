import 'dart:convert';
import 'dart:ffi';

import 'dart:typed_data';

/// Array of heap allocated memory.
/// [T] must be the suitable TypedData for the native type [N].
///
/// Example:
/// ````
/// MemoryArray<Uint8, Uint8List>();
/// MemoryArray<Int16, Int16List>();
/// ````
class MemoryArray<N extends NativeType, T extends List<int>> {
  /// Pointer to the first element
  final Pointer<N> rawPtr;
  T _view;

  /// View into the array. Changes to the view will change the underlying memory.
  T get view => _view;

  /// Address of the first element
  int get address => rawPtr.address;

  /// Length of the array
  int get length => _view.length;

  MemoryArray.fromTypedData(T data)
      : rawPtr = Pointer<N>.allocate(count: data.length) {
    _view = rawPtr.asExternalTypedData(count: data.length) as List;
    (_view).setAll(0, data);
  }

  /// Move [rawPtr] to a new MemoryArray. Don't free [rawPtr] manually.
  MemoryArray.fromRawPointer(this.rawPtr, {int count = 1}) {
    _view = rawPtr.asExternalTypedData(count: count) as T;
  }

  /// Allocates an array with [count] elements of [N]
  MemoryArray.allocate({int count = 1})
      : assert(count > 0, "count must be bigger than 1"),
        rawPtr = Pointer.allocate(count: count) {
    _view = rawPtr.asExternalTypedData(count: count) as T;
  }

  /// Frees the allocated memory.
  /// Don't forget to call or there might be a memory leak.
  /// Consider Exceptions.
  void free() {
    rawPtr.free();
  }
}

/// Helper class which deals with fixed sized char arrays.
///
/// If you need a Null terminated Cstring you can do that easily:
/// ````
/// // using the Null character
/// final cstr = "Some String\x00";
/// // set last entry to '0'
/// list.last = 0;
/// ````
class CharArray extends MemoryArray<Uint8, Uint8List> {
  CharArray.fromUint8List(Uint8List str) : super.fromTypedData(str);
  CharArray.fromRawPointer(Pointer<Uint8> ptr, {int count = 1})
      : super.fromRawPointer(ptr, count: count);
  CharArray.allocate({int count = 1}) : super.allocate(count: count);
  static CharArray fromUtf8String(String str) {
    final encodedStr = utf8.encode(str);
    final char = CharArray.fromUint8List(encodedStr);
    return char;
  }

  String toUtf8String() {
    return utf8.decode(view);
  }
}
