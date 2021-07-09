import 'dart:convert';
import 'dart:io';
import 'package:sweetgiftbox/screen/feedpage.dart';

import '/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'mainscreen.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import '../model/user.dart';

class AddFeedScreen extends StatefulWidget {
  final User user;

  const AddFeedScreen({Key? key, required this.user}) : super(key: key);
  @override
  _AddFeedScreenState createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  late AnimationController controller;
  late FutureProgressDialog pr;
  late double screenHeight, screenWidth;
  TextEditingController _descriptionController = new TextEditingController();
  late File _image;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.pink,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => FeedPage(user: widget.user)));
                setState(() {});
              }),
          title: Text(
            "Feedback",
            style: TextStyle(color: Colors.white),
          )),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _chooseImage();
            },
            child: Icon(Icons.camera, size: 80),
          ),
          SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            child: Text('Click to upload picture'),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.all(8),
            child: TextField(
              maxLines: 10,
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 60, 20, 15),
                  hintText: 'Write a post',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 8.0, right: 8.0, bottom: 20),
            child: Center(
              child: Container(
                  height: 50,
                  width: 100,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.pink,
                    onPressed: () {
                      _addDialog();
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Post",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                  )),
            ),
          ),
        ],
      )),
    );
  }

  void _chooseImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: Text("Camera/Gallery"), children: <Widget>[
            SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  _chooseGallery();
                },
                child: const Text('Choose From Gallery')),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                _chooseCamera();
              },
              child: const Text('Take a photo'),
            )
          ]);
        });
  }

  Future<void> _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print("No Image Selected");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => AddFeedScreen(
                    user: widget.user,
                  )));
    }
    _cropImage();
  }

  Future<void> _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print("No Image Selected");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => AddFeedScreen(
                    user: widget.user,
                  )));
    }
    _cropImage();
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).accentColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  Future<void> _addFeed() async {
    pr = FutureProgressDialog(getFuture());
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: Text('Uploading package')),
    );
    showResultDialog(context, result);

    String description = _descriptionController.text.toString();
    String images = base64Encode(_image.readAsBytesSync());

    http.post(Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/newfeed.php"),
        body: {
          "description": description,
          "encoded_string": images,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Successfully added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(user: widget.user)));
      } else {
        Fluttertoast.showToast(
            msg: "Failed to add",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        return;
      }
    });
  }

  void _addDialog() {
    // ignore: unnecessary_null_comparison
    if (_image == null || _descriptionController.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Image/Textfield is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Confirm to upload"),
            actions: [
              TextButton(
                child: Text("Confirm", style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addFeed();
                },
              ),
              TextButton(
                  child: Text("Cancel", style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Loading...';
    });
  }

  void showResultDialog(BuildContext context, result) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(content: Text(result), actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ]));
  }
}
