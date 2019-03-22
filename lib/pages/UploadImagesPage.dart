import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivi_bday_app/helper_classes/ImageList.dart';

class UploadImagesPage extends StatefulWidget {
  @override
  _UploadImagesPageState createState() => _UploadImagesPageState();
}

class _UploadImagesPageState extends State<UploadImagesPage> {

  final List<File> imageList = [];
  File uploadedImage;
  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageList.add(tempImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: uploadImage,
                    child: Text('Upload Image'), color: Theme
                      .of(context)
                      .primaryColor,
                  ),
                ),
                Expanded(child: ImageList(imageList))
                //uploadedImage == null? Text(""): enableUpload(),
              ],
            )
        ),
      ),
    );
  }


}

