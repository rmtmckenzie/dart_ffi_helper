import 'package:ffi_helper/ffi_helper.dart';

// AutoFreeGroup can be easily extended or embedded to make usage more comfortable
class MyAutoFreeGroup extends AutoFreeGroup {
  MemoryArray mem1, mem2, mem3;
  MyAutoFreeGroup(MemoryArray mem1, MemoryArray mem2, MemoryArray mem3,
      {Duration freeAfter})
      : super(onAllocate: () => [mem1, mem2, mem3]) {
    mem1 = arrays[0];
    mem2 = arrays[1];
    mem3 = arrays[2];
  }
}
