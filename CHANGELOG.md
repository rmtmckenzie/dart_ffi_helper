## 1.0.0

- Initial version, created by Stagehand

## 1.1.0 
**breaking changes due to changes to the ffi in Dart 2.6**
- MemoryArray is now an abstract class which can be extended by typed *NativeType*Array (eg Uint8Array). This increases type safety and is in accordance with the changes to the ffi.
- New class Uint8Array which extends MemoryArray. For now this is the only typed *NativeType*Array.
- remove CharArray. Use new Uint8Array.
