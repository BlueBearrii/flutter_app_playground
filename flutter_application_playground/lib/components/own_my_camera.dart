import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OwnMyCamera extends StatefulWidget {
  @override
  _OwnMyCameraState createState() => _OwnMyCameraState();
}

class _OwnMyCameraState extends State<OwnMyCamera> {
  bool isLoading = false;
  File imageFile;
  Future _isCameraOnPress(ImageSource imageSource) async {
    try {
      var obj = await ImagePicker.pickImage(source: imageSource);
      _onProcessImage(obj);
    } catch (errors) {}
  }

  _onProcessImage(image) {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        isLoading = false;
        imageFile = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () {
            _isCameraOnPress(ImageSource.camera);
          },
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                child:
                    imageFile == null ? Text("IMAGE") : Image.file(imageFile),
              ),
            ),
            isLoading
                ? SizedBox.expand(
                    child: Container(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        child: Center(child: CircularProgressIndicator())),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
