import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'package:aruco_detect/native_add.dart';
import 'package:aruco_detect/main.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:dio/dio.dart';

int x = 0;
int errorId = 0;
Pointer<Int> markerId = markerIdFunc();
Pointer<Double> cX = cXFunc();
Pointer<Double> cY = cYFunc();
Pointer<Double> tLX = tLXFunc();
Pointer<Double> tLY = tLYFunc();
Pointer<Double> tRX = tRXFunc();
Pointer<Double> tRY = tRYFunc();
Pointer<Double> bRX = bRXFunc();
Pointer<Double> bRY = bRYFunc();
Pointer<Double> bLX = bLXFunc();
Pointer<Double> bLY = bLYFunc();

var codeMap = new Map();
var defineMap = new Map();
var repeatMap = new Map();
var setItemList = [];
var replaceItemList = [];
String json = '';
String errorMsg = '';
var responseData = new Map();
String downloadURL = '';

void addX() {
  x++;
}

int getTokenNum() {
  if (x < cnt) {
    return markerId.elementAt(x).value;
  }
  else {
    return -1;
  }
}

class draw extends CustomPainter {
  final UI.Image? img;

  draw(this.img);

  @override
  void paint(Canvas canvas, UI.Size size) async {
    var paint = Paint()
      ..strokeWidth = 2.5
      ..color = Colors.green;
    var paint2 = Paint()
      ..color = Colors.blue;
    var paint3 = Paint()
      ..strokeWidth = 2.5
      ..color = Colors.red;
    if(img != null) {
      canvas.drawImage(img!, Offset(30, 0), paint);
      for (int i = 0 ; i < errorId; i++) {
        canvas.drawCircle(Offset((cX.elementAt(i).value / 4) + 30, (cY.elementAt(i).value / 4) + 10), 2, paint2);
        canvas.drawLine(Offset((tLX.elementAt(i).value / 4) + 30, (tLY.elementAt(i).value / 4) + 10), Offset((tRX.elementAt(i).value / 4) + 30, (tRY.elementAt(i).value / 4) + 10), paint);
        canvas.drawLine(Offset((tRX.elementAt(i).value / 4) + 30, (tRY.elementAt(i).value / 4) + 10), Offset((bRX.elementAt(i).value / 4) + 30, (bRY.elementAt(i).value / 4) + 10), paint);
        canvas.drawLine(Offset((bRX.elementAt(i).value / 4) + 30, (bRY.elementAt(i).value / 4) + 10), Offset((bLX.elementAt(i).value / 4) + 30, (bLY.elementAt(i).value / 4) + 10), paint);
        canvas.drawLine(Offset((bLX.elementAt(i).value / 4) + 30, (bLY.elementAt(i).value / 4) + 10), Offset((tLX.elementAt(i).value / 4) + 30, (tLY.elementAt(i).value / 4) + 10), paint);
      }
      if (errorId != cnt) {
        canvas.drawCircle(Offset((cX.elementAt(errorId).value / 4) + 30, (cY.elementAt(errorId).value / 4) + 10), 2, paint3);
        canvas.drawLine(Offset((tLX.elementAt(errorId).value / 4) + 30, (tLY.elementAt(errorId).value / 4) + 10), Offset((tRX.elementAt(errorId).value / 4) + 30, (tRY.elementAt(errorId).value / 4) + 10), paint3);
        canvas.drawLine(Offset((tRX.elementAt(errorId).value / 4) + 30, (tRY.elementAt(errorId).value / 4) + 10), Offset((bRX.elementAt(errorId).value / 4) + 30, (bRY.elementAt(errorId).value / 4) + 10), paint3);
        canvas.drawLine(Offset((bRX.elementAt(errorId).value / 4) + 30, (bRY.elementAt(errorId).value / 4) + 10), Offset((bLX.elementAt(errorId).value / 4) + 30, (bLY.elementAt(errorId).value / 4) + 10), paint3);
        canvas.drawLine(Offset((bLX.elementAt(errorId).value / 4) + 30, (bLY.elementAt(errorId).value / 4) + 10), Offset((tLX.elementAt(errorId).value / 4) + 30, (tLY.elementAt(errorId).value / 4) + 10), paint3);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void ID() {
  if (getTokenNum() == 2) {
    //arrayJ
    if (!setItemList.contains("j")) {
      setItemList.add("j");
    }
    if (!defineMap.containsKey('set')) {
      defineMap.addAll({'set':setItemList});
    }
    addX();
  }
  else if (getTokenNum() == 3) {
    //"arrayPlus"
    if (!replaceItemList.contains("j+1")) {
      replaceItemList.add("j+1");
    }
    if (!defineMap.containsKey('replace')) {
      defineMap.addAll({'replace':replaceItemList});
    }
    addX();
  }
  else if (getTokenNum() == 6) {
    //"boat"
    if (!replaceItemList.contains("boat")) {
      replaceItemList.add("boat");
    }
    if (!defineMap.containsKey('replace')) {
      defineMap.addAll({'replace':replaceItemList});
    }
    addX();
  }
  else {
    errorId = x;
    errorMsg = 'Syntax Error';
  }
}

void TIME() {
  if (getTokenNum() == 4) {
    //"arrayLength"
    repeatMap.addAll({'time':'length'});
    addX();
    stats();
  }
  else if (getTokenNum() == 5) {
    //"arrayLengthInloop"
    addX();
    stats();
  }
  else {
    errorId = x;
    errorMsg = 'Syntax Error';
  }
}

void stats() {
  if (getTokenNum() == 13 || getTokenNum() == 14 || getTokenNum() == 15 || getTokenNum() == 16 || getTokenNum() == 17) {
    if (getTokenNum() == 13) {
      //"setArray"
      if (!replaceItemList.contains("j")) {
        replaceItemList.add("j");
      }
    }
    else if (getTokenNum() == 14) {
      //"setArrayPlus"
      if (!replaceItemList.contains("j+1")) {
        replaceItemList.add("j+1");
      }
    }
    else if (getTokenNum() == 15) {
      //"setBoat"
      if (!setItemList.contains("boat")) {
        setItemList.add("boat");
      }
    }
    else if (getTokenNum() == 16) {
      //"setI"
    }
    else if (getTokenNum() == 17) {
      //"setJ"
    }
    addX();
    ID();
  }
  else if (getTokenNum() == 2 || getTokenNum() == 3 || getTokenNum() == 6) {
    if (getTokenNum() == 2) {
      //"arrayJ"
      if (!setItemList.contains("j")) {
        setItemList.add("j");
      }
      if (!defineMap.containsKey('set')) {
        defineMap.addAll({'set':setItemList});
      }
    }
    else if (getTokenNum() == 3) {
      //"arrayPlus"
      if (!replaceItemList.contains("j+1")) {
        replaceItemList.add("j+1");
      }
      if (!defineMap.containsKey('replace')) {
        defineMap.addAll({'replace':replaceItemList});
      }
    }
    else if (getTokenNum() == 6) {
      //"boat"
      if (!replaceItemList.contains("boat")) {
        replaceItemList.add("boat");
      }
      if (!defineMap.containsKey('replace')) {
        defineMap.addAll({'replace':replaceItemList});
      }
    }
    addX();
  }
  else if (getTokenNum() == 1) {
    //"add"
    addX();
    if (getTokenNum() == 19) {
      //"10"
    }
    else if (getTokenNum() == 20) {
      //"7"
    }
    else if (getTokenNum() == 21) {
      //"3"
    }
    else if (getTokenNum() == 22) {
      //"1"
    }
    else if (getTokenNum() == 23) {
      //"6"
    }
    else {
      errorId = x;
      errorMsg = 'add must connect to number';
    }
  }
  else if (getTokenNum() == 8) {
    //"if"
    repeatMap.addAll({'if':'NaN'});
    addX();
    if (getTokenNum() == 9) {
      //"ifCon"
      if (repeatMap.containsKey('if')) {
        repeatMap.update('if', (value) => 'JMorethanJplus');
      }
      addX();
      if (getTokenNum() == 18) {
        //"swap"
        repeatMap.addAll({'codetype':'swap'});
        addX();
      }
      else {
        errorId = x;
        errorMsg = 'ifCon must connect to swap';
      }
    }
    else {
      errorId = x;
      errorMsg = 'if must connect to ifCon';
    }
  }
  else if (getTokenNum() == 12) {
    //"repeat"
    codeMap.addAll({'repeat':repeatMap});
    addX();
    TIME();
  }
  else {
    errorId = x;
    errorMsg = 'Syntax Error';
  }
}

void funcdef() {
  if (getTokenNum() == 7) {
    //"define"
    codeMap.addAll({'define':defineMap});
    addX();
    stats();
  }
  else {
    errorId = x;
    errorMsg = 'Syntax Error';
  }
}

void plus() {
  if (getTokenNum() == 10) {
    //"iPlus"
  }
  else if (getTokenNum() == 11) {
    //"jPlus"
  }
  else {
    errorId = x;
    errorMsg = 'Syntax Error';
  }
}

void match(int i) {
  if (i == 1) {
    stats();
  }
  else if (i == 2 || i == 3 || i == 6) {
    ID();
  }
  else if (i == 4 || i == 5) {
    TIME();
  }
  else if (i == 7) {
    funcdef();
  }
  else if (i == 8) {
    stats();
  }
  else if (i == 10 || i == 11) {
    plus();
  }
  else if (i == 12 || i == 13 || i == 14 || i == 15 || i == 16 || i == 17) {
    stats();
  }
  else {
    errorId = x;
    errorMsg = 'Syntax Error';
  }
}

void detection() {
  errorId = cnt;
  x = 0;
  codeMap = new Map();
  defineMap = new Map();
  repeatMap = new Map();
  setItemList = [];
  replaceItemList = [];
  json = '';
  errorMsg = '';
  downloadURL = '';
  responseData = new Map();
  while (errorId == cnt && x < cnt) {
    match(markerId.elementAt(x).value);
  }
  if (errorId == cnt) {
    json = jsonEncode(codeMap);
    uploadFile();
  }
}

uploadFile() async {
  String url = "https://api.upload.io/v1/files/basic";
  Dio dio = new Dio();
  dio.options.headers["Authorization"] = 'Bearer public_kW15aumGhMJMi7CrFLvewbctb6kx';
  dio.options.headers["Content-Type"] = 'application/json';
  Response response = await dio.post(url, data: json);
  responseData = response.data;
  downloadURL = responseData['fileUrl'];
  //print(response.statusCode);
}