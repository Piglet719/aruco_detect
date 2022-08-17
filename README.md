# aruco_detect

Each ArUco represents a token.

The tokens' meaning and grammer can see [grammer.md](grammer.md).

An app can detect aruco and determine whether the syntax is correct or not.

![demo](demo.gif)

## Getting Started

Because flutter doesn't include ArUco library, we need use OpenCV4 with contrib in native C++ of flutter.

**Step 0:** Go to download OpenCV4 and OpenCV Contrib which includes ArUco library.

**Step 1:** Use Cmake to compile and run "opencv/platforms/android/build_sdk.py", then you can get sdk of OpenCV with OpenCV with Contrib or you can directly download [here](https://github.com/Piglet719/OpenCV-android-sdk-with-OpenCV-Contrib.git).

**Step 2:** Write your C++ code and put in "android/app/src/main/cpp".

**Step 3:** Create a CmakeList.txt in the "android/app".

**Step 4:**
1. Copy OpenCV SDk "sdk/native/jni/include" to "android/app/src/main/cpp".
2. Copy OpenCV SDk "sdk/native/staticlibs" to "android/app/src/main/jniLibs".
3. Copy OpenCV SDk "sdk/native/3rdparty" to "android/app/src/main/3rdparty".

## Usage

1. To sort the ArUco according to the syntax of code.

2. Take a picture by the app.

3. Select the picture and click detect (the qrcode icon).

4. Then, you can see the green mark and if the code is incorrect, the mark will present red.

#### References

- https://stackoverflow.com/questions/63127202/how-to-use-opencv-4-in-native-c-of-flutter-in-2022-support-flutter-2-0-3-0

- https://juejin.cn/post/6976824832595853342