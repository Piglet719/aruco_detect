import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;
import 'package:aruco_detect/native_add.dart';
import 'package:aruco_detect/detection.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image/image.dart' as IMG;
import 'package:flutter/src/widgets/image.dart' as WIMG;


void main() => runApp(MyApp());

int cnt = 0;
int imgWidth = 0;
int imgHeight = 0;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<MyHomePage> {
  var _imgPath;
  int detected = 0;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ArUco Detect"),
        elevation: 4.0,
        leading: Builder(
          builder: (context){
            return IconButton(
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.dashboard_outlined)
            );
          },
        ),
      ),
      drawer: Drawer(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipOval(
                        child: WIMG.Image.asset("assets/piglet.jpg", width: 80, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                    Text(
                      "Piglet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _ImageView()
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                onPressed: (){
                  _openGallery();
                },
                icon: Icon(Icons.switch_account)
            ),
            SizedBox(),
            IconButton(
                onPressed: () async{
                  if (_imgPath == null) {
                    Fluttertoast.showToast(
                        msg: "Please select the photo first!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else {
                    String str = _imgPath;
                    cnt = detectFunc(str.toNativeUtf8().cast<Uint8>(), imgWidth, imgHeight);
                    if (cnt == 0) {
                      Fluttertoast.showToast(
                          msg: "No ArUco was detected",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else {
                      detection();
                      setState(() {
                        detected = 1;
                      });
                      _ImageView();
                    }
                  }
                },
                icon: Icon(Icons.qr_code_scanner)
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt_outlined),
        onPressed: (){
          _takePhoto();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _ImageView() {
    if (_imgPath == null) {
      return Center(
          child: Text("Please select the photo or take a picture")
      );
    }
    else if (detected == 0){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: WIMG.Image.file(
              File(_imgPath),
              width: 300,
            ),
          ),
        ],
      );
    }
    else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: FutureBuilder(
                  future: getImg(_imgPath),
                  builder: (BuildContext context, AsyncSnapshot<UI.Image>snapshot){
                    return CustomPaint(
                      painter: draw(snapshot.data),
                    );
                  }
              )
          ),
        ],
      );
    }
  }

  Future<UI.Image> getImg(String asset) async {
    File file = File(asset);
    Uint8List bytes = file.readAsBytesSync() as Uint8List;
    UI.Codec codec = await UI.instantiateImageCodec(bytes, targetWidth: 300, targetHeight: 550);
    UI.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  _takePhoto() async {
    var image = await picker.pickImage(source: ImageSource.camera);

    GallerySaver.saveImage(image!.path)
        .then((bool? success) {
      setState(() {
        Fluttertoast.showToast(
            msg: "Save successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });
    });
  }

  _openGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    _resizeImg(image!.path);
    File file = File(image.path);
    final size = ImageSizeGetter.getSize(FileInput(file));

    setState(() {
      imgWidth = size.width;
      imgHeight = size.height;
      detected = 0;
      _imgPath = image.path;
    });
  }

  _resizeImg(String path) {
    IMG.Image img = IMG.decodeImage(new File(path).readAsBytesSync())!;

    IMG.Image thumbnail = IMG.copyResize(img, width: 1200);

    new File(path)
      ..writeAsBytesSync(IMG.encodePng(thumbnail));
  }
}