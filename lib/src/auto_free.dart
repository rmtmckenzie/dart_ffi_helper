part of "memory_array.dart";

abstract class AutoFreeMemoryArray<N extends NativeType>
    implements MemoryArray<N> {
  final bool zeroBeforeFree;
  RestartableTimer _timer;
  Pointer<N> _rawPtr;
  Pointer<N> get rawPtr {
    _timer.reset();
    if (_rawPtr == null) {
      _rawPtr = ffi.allocate(count: view.length);
      final tmpView = _asTypedList(_rawPtr, view.length);
      tmpView.setAll(0, view);
      _view = tmpView;
    }
    return _rawPtr;
  }

  AutoFreeMemoryArray.fromTypedList(List<int> data,
      {Duration freeAfter = const Duration(minutes: 2),
      this.zeroBeforeFree = false}) {
    _timer = RestartableTimer(freeAfter, free);
  }

  void free() {
    if (zeroBeforeFree) {
      _view.fillRange(0, _view.length - 1, 0);
    }
    ffi.free(rawPtr);
    _rawPtr = null;
    _timer.cancel();
  }
}
