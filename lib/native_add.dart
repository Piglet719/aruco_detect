import 'dart:core';
import 'dart:ffi';
import 'dart:io';

final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative-lib.so")
    : DynamicLibrary.process();

// send picture's path to c++, return cnt to dart
final int Function(Pointer<Uint8>, int, int) detectFunc = nativeAddLib.lookup<NativeFunction<Int Function(Pointer<Uint8>, Int, Int)>>("detect").asFunction();

// return markerId
final Pointer<Int> Function() markerIdFunc = nativeAddLib.lookup<NativeFunction<Pointer<Int> Function()>>("markerId").asFunction();

// return centerX
final Pointer<Double> Function() cXFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("cX").asFunction();

// return centerY
final Pointer<Double> Function() cYFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("cY").asFunction();

// return topLeftX
final Pointer<Double> Function() tLXFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("tLX").asFunction();

// return topLeftY
final Pointer<Double> Function() tLYFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("tLY").asFunction();

// return topRightX
final Pointer<Double> Function() tRXFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("tRX").asFunction();

// return topRightY
final Pointer<Double> Function() tRYFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("tRY").asFunction();

// return bottomRightX
final Pointer<Double> Function() bRXFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("bRX").asFunction();

// return bottomRightY
final Pointer<Double> Function() bRYFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("bRY").asFunction();

// return bottomLeftX
final Pointer<Double> Function() bLXFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("bLX").asFunction();

// return bottomLeftY
final Pointer<Double> Function() bLYFunc = nativeAddLib.lookup<NativeFunction<Pointer<Double> Function()>>("bLY").asFunction();