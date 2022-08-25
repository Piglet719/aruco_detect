# aruco_detection

Each ArUco represents a token.

The tokens' meaning and grammer can see [grammer.md](grammer.md).

The app can detect aruco and determine whether the syntax is correct or not and convert to the scratch animation.

![demo](demo3.gif)

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

1. Generate the ArUco markers in advance.

2. To sort the ArUco according to the syntax of code.

3. Take a picture by the app, and it will save automatically.

4. Select the picture from the gallery and click detect (the qrcode icon).

5. Then, you can see the green mark and if the code is incorrect, the mark will present red and show the error. At the same time, if the code is correct, the system will generate json and upload to server automatically.

6. Then you can click the JS icon to see the json and click the middle button to get a url. Otherwise, it will ask you to sort correctly.

7. After getting the url, you can click the video icon to go to the scratch website. Import the written code, change the url and click the green flag, then you can see the numbers sort correctly.

#### References

- https://stackoverflow.com/questions/63127202/how-to-use-opencv-4-in-native-c-of-flutter-in-2022-support-flutter-2-0-3-0

- https://juejin.cn/post/6976824832595853342