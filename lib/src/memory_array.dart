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

  /// Length of [view];
  int get length => _view.length;

  MemoryArray.fromTypedList(List<int> data) : rawPtr = ffi.allocate<N>(count: data.length) {
    _view = _asTypedList(rawPtr, data.length);
    (_view).setAll(0, data);
  }

  /// Move [rawPtr] to a new MemoryArray. Don't free [rawPtr] manually.
  MemoryArray.fromPointer(this.rawPtr, {int count = 1}) {
    _view = _asTypedList(rawPtr, count);
  }

  /// Allocates an array with [count] elements of [N]
  MemoryArray.allocate({int count = 1})
      : assert(count > 0, 'count must be bigger than 1'),
        rawPtr = ffi.allocate(count: count) {
    _view = _asTypedList(rawPtr, count);
  }

  MemoryArray.nullPointer()
      : rawPtr = nullptr.cast(),
        _view = const [];

  List<int> _asTypedList(Pointer<N> ptr, int length);

  /// Frees the allocated memory.
  /// Don't forget to call or there might be a memory leak.
  /// Consider Exceptions.
  void free() {
    ffi.free(rawPtr);
  }

  int operator [](int i) {
    return _view[i];
  }

  void operator []=(int i, int val) {
    _view[i] = val;
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

class Uint16Array extends MemoryArray<Uint16> {
  @override
  Uint16List get view => _view;

  Uint16Array.fromTypedList(Uint16List data) : super.fromTypedList(data);

  Uint16Array.fromPointer(Pointer<Uint16> ptr) : super.fromPointer(ptr);

  Uint16Array.allocate({int count = 1}) : super.allocate(count: count);

  @override
  Uint16List _asTypedList(Pointer<Uint16> ptr, int length) {
    return ptr.asTypedList(length);
  }
}

class Uint32Array extends MemoryArray<Uint32> {
  @override
  Uint32List get view => _view;

  Uint32Array.fromTypedList(Uint32List data) : super.fromTypedList(data);

  Uint32Array.fromPointer(Pointer<Uint32> ptr) : super.fromPointer(ptr);

  Uint32Array.allocate({int count = 1}) : super.allocate(count: count);

  @override
  Uint32List _asTypedList(Pointer<Uint32> ptr, int length) {
    return ptr.asTypedList(length);
  }
}

class Uint64Array extends MemoryArray<Uint64> {
  @override
  Uint64List get view => _view;

  Uint64Array.fromTypedList(Uint64List data) : super.fromTypedList(data);

  Uint64Array.fromPointer(Pointer<Uint64> ptr) : super.fromPointer(ptr);

  Uint64Array.allocate({int count = 1}) : super.allocate(count: count);

  @override
  Uint64List _asTypedList(Pointer<Uint64> ptr, int length) {
    return ptr.asTypedList(length);
  }
}
