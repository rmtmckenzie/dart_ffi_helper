Provides some functionality to make working with the FFI a little easier.

## Usage

```dart
import 'package:ffi_helper/ffi_helper.dart';

main() {
  final array = MemoryArray<Uint8, Uint8List>.fromTypedData(someUint8List);
  someFFIfunction(array.rawPtr);

  final cstr = CharArray.fromUtf8String("some String");
  readCstr(cstr.rawPtr); 

  final emptyCstr = CharArray.allocate(count: lengthOfCstr);
  writeToCstr(emptyCstr.rawPtr)
}
```

This software is in the public domain:
[unlicense](https://gitlab.com/MagicGuitar/dart_ffi_helper/UNLICENSE)