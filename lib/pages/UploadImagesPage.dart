import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//Firebase storage plugin
import 'package:firebase_storage/firebase_storage.dart';

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
    return MaterialApp(
      home: Scaffold(
        body: Center (
          child: Column (
            children: <Widget>[
              Container(
                child: RaisedButton(
                  onPressed: uploadImage,
                  child: Text('Upload Image'), color: Theme.of(context).primaryColor,
                ),
              ),
            sampleImage == null? Text(""): enableUpload(),
            ],
          )
        ),
      ),
    );
  }

  Widget enableUpload() {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref().child('myImage.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width/1.5)
        ],
      )
    );
  }
}

