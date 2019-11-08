part of "memory_array.dart";

/// Frees allocated memory when it isn't accessed for a specified duration.
/// If it gets accessed again, new memory will be allocated.
@experimental
@sealed
class AutoFree<N extends NativeType> implements MemoryArray<N> {
  RestartableTimer _timer;
  MemoryArray<N> _array;

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

  List<int> _asTypedList(Pointer<N> ptr, int length) => null;
  var _view;
}
