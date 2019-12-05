import "package:meta/meta.dart";
import 'memory_array.dart';
import 'package:async/async.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'dart:collection';

/// Frees allocated memory when it isn't accessed for a specified duration.
/// If it gets accessed again, new memory will be allocated.
@experimental
@sealed
class AutoFree<N extends NativeType> implements MemoryArray<N> {
  RestartableTimer _timer;
  MemoryArray<N> _array;

  int get length => _array.length;

  int operator [](int i) => _array[i];
  void operator []=(int i, int val) => _array[i] = val;

  /// Gets invoked when memory is freed automatically.
  void Function(MemoryArray<N> memArr) onFree = (MemoryArray<N> memArr) {};

  /// Gets invoked when new Memory is allocated
  final MemoryArray<N> Function() onAllocate;
  Pointer<N> get rawPtr {
    _reset();
    return _array.rawPtr;
  }

  List<int> get view {
    _reset();
    return _array.view;
  }

  void _reset() {
    _timer.reset();
    if (_array == null) {
      _array = onAllocate();
    }
  }

  AutoFree(
      {Duration freeAfter = const Duration(minutes: 2),
      @required this.onAllocate,
      this.onFree}) {
    _array = onAllocate();
    _timer = RestartableTimer(freeAfter, free);
  }

  /// Frees the allocated memory. Doing so manually has the same effect as waiting
  /// for it to be freed automatically. Calling this method when memory has been freed has no effect.
  void free() {
    if (_array == null) return;
    _timer.cancel();
    onFree(this._array);
    _array.free();
    _array = null;
  }
}

/// Manages multiple [MemoryArray]s and works just like it.
@experimental
class AutoFreeGroup {
  @nonVirtual
  List<MemoryArray> _arrays;

  /// Gets invoked when memory gets allocated.
  @nonVirtual
  List<MemoryArray> Function() onAllocate;

  /// Gets invoked when memory gets freed.
  @nonVirtual
  void Function(List<MemoryArray>) onFree = (List<MemoryArray> arrays) {};
  RestartableTimer _timer;

  AutoFreeGroup(
      {Duration freeAfter = const Duration(minutes: 2),
      @required this.onAllocate,
      this.onFree})
      : _arrays = onAllocate() {
    _timer = RestartableTimer(freeAfter, free);
  }

  @nonVirtual
  UnmodifiableListView<MemoryArray> get arrays {
    _reset();
    return UnmodifiableListView(_arrays);
  }

  void _reset() {
    _timer.reset();
    if (_arrays == null) {
      _arrays = onAllocate();
    }
  }

  /// Frees all [MemoryArray]s and invokes [onFree].
  /// Does nothing when memory has been freed already.
  @nonVirtual
  void free() {
    if (_arrays == null) return;
    _timer.cancel();
    onFree(_arrays);
    _arrays.forEach((arr) => ffi.free(arr.rawPtr));
    _arrays = null;
  }
}
