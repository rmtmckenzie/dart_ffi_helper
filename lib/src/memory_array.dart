import 'dart:convert';
import 'dart:ffi';

import 'dart:typed_data' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;

/// Array of heap allocated memory.
abstract class MemoryArray<N extends NativeType> {
  /// Pointer to the first element
  final Pointer<N> rawPtr;
  List<int> _view;

  /// View into the allocated memory.
  /// Changes to the view will also change the
  /// content of the underlying memory.
  List<int> get view;

  MemoryArray.fromTypedList(List<int> data)
      : rawPtr = ffi.allocate<N>(count: data.length) {
    _view = _asTypedList(rawPtr, data.length);
    (_view).setAll(0, data);
  }

  /// Move [rawPtr] to a new MemoryArray. Don't free [rawPtr] manually.
  MemoryArray.fromPointer(this.rawPtr, {int count = 1}) {
    _view = _asTypedList(rawPtr, count);
  }

  /// Allocates an array with [count] elements of [N]
  MemoryArray.allocate({int count = 1})
      : assert(count > 0, "count must be bigger than 1"),
        rawPtr = ffi.allocate(count: count) {
    _view = _asTypedList(rawPtr, count);
  }

  List<int> _asTypedList(Pointer<N> ptr, int length);

  /// Frees the allocated memory.
  /// Don't forget to call or there might be a memory leak.
  /// Consider Exceptions.
  void free() {
    ffi.free(rawPtr);
  }
}

class Uint8Array extends MemoryArray<Uint8> {
  @override
  Uint8List get view => _view;

  Uint8Array.fromTypedList(Uint8List data) : super.fromTypedList(data);
  Uint8Array.fromPointer(Pointer<Uint8> ptr) : super.fromPointer(ptr);
  Uint8Array.allocate({int count = 1}) : super.allocate(count: count);
  Uint8Array.fromUtf8(String str) : super.allocate(count: str.length) {
    final encoded = utf8.encode(str);
    _view.setAll(0, encoded);
  }

  @override
  Uint8List _asTypedList(Pointer<Uint8> ptr, int length) {
    return ptr.asTypedList(length);
  }
}
