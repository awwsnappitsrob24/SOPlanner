import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagesPage extends StatefulWidget {
  @override
  _UploadImagesPageState createState() => _UploadImagesPageState();
}

class _UploadImagesPageState extends State<UploadImagesPage> {

  File sampleImage;

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column (
          // Centralize button in the page
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Container(
              child: RaisedButton(
                onPressed: uploadImage,
                child: Text('Upload Image'), color: Theme.of(context).primaryColor,
              ),
            )
          ],


        ),
      ),

    );
  }
}
