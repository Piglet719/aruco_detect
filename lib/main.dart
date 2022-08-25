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
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

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
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

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
                        child: Image.asset("assets/piglet.jpg", width: 80, height: 80, fit: BoxFit.cover),
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
      body: _ImageView(),
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
                    cnt = detectFunc(str.toNativeUtf8().cast<Uint8>());
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
                      if (cnt != errorId) {
                        showAlertDialog(context);
                      }
                    }
                  }
                },
                icon: Icon(Icons.qr_code_scanner)
            ),
            SizedBox(),
            IconButton(
                onPressed: (){
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
                    setState(() {
                      detected = 2;
                    });
                    _ImageView();
                  }
                },
                icon: Icon(Icons.javascript_sharp)
            ),
            IconButton(
                onPressed: (){
                  _launchScratch();
                },
                icon: Icon(Icons.video_call_outlined)
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
    else if (detected == 0) {
      return SingleChildScrollView(
          child: Center(
            child: Image.file(
              File(_imgPath),
              width: 300,
            ),
          )
      );
    }
    else if (detected == 1) {
      return SingleChildScrollView(
          child: FutureBuilder(
              future: getImg(_imgPath),
              builder: (BuildContext context, AsyncSnapshot<UI.Image>snapshot){
                return CustomPaint(
                  painter: draw(snapshot.data),
                );
              }
          )
      );
    }
    else {
      if (json.isEmpty) {
        return Center(
            child: Text("Please sort the ArUco correctly!")
        );
      }
      else {
        return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(json),
                ElevatedButton.icon(
                  icon: Icon(Icons.cloud_download),
                  label: Text("get URL"),
                  onPressed: (){
                    showResultDialog(context);
                  },
                ),
              ],
            )
        );
      }
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

    setState(() {
      detected = 0;
      _imgPath = image!.path;
    });
  }

  _launchScratch() async {
    Uri _url = Uri(scheme: 'https', host: 'ys-fang.github.io', path: 'OSEP/app/');
    if (!await launchUrl(_url, mode: LaunchMode.externalNonBrowserApplication)) {
      throw 'Could not launch $_url';
    }
  }

  showAlertDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("Error Message"),
      content: Text(errorMsg),
      actions: [
        ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ],
    );

    // Show the dialog (showDialog() => showGeneralDialog())
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {return Wrap();},
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            (1.0-Curves.easeInOut.transform(anim1.value))*400,
            0.0,
          ),
          child: dialog,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  showResultDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("URL"),
      content: Text(downloadURL),
      actions: [
        ElevatedButton(
            child: Text("COPY"),
            onPressed: () {
              _copyToClipboard();
            }
        ),
        ElevatedButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ],
    );

    // Show the dialog (showDialog() => showGeneralDialog())
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {return Wrap();},
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            (1.0-Curves.easeInOut.transform(anim1.value))*400,
            0.0,
          ),
          child: dialog,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: downloadURL));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }
}