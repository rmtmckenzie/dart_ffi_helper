import 'dart:typed_data';

import 'package:ffi_helper/ffi_helper.dart';

main(List<String> args) {
  // AutoFree automates memory management.
  // Experimental!
  final auto = AutoFree(
      // Function that allocates a MemoryArray which then gets manages by AutoFree.
      onAllocate: () => Uint8Array.fromTypedList(Uint8List.fromList([1, 2, 3])),
      // Optional function which gets invoked when the memory is about to get freed.
      onFree: (MemoryArray m) {
        print(m.view);
      },
      // Time after which the memory gets freed automatically.
      freeAfter: Duration(seconds: 30));

  // You can still free the memory manually. [onFree] gets fired as well.
  auto.free();
}
