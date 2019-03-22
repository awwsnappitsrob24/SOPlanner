import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageList extends StatelessWidget {

  // Builder methods rely on a set of data, such as a list.
  //File uploadedImage;
  final List<File> images;
  ImageList(this.images);

  @override
  Widget build(BuildContext context) {
    return _buildImageList(context);
  }

  Widget _buildImageItem(BuildContext context, int index) {
    //var imageAcquired = images[index];
    //images.add(imageAcquired);
    if(images[index].path.toString() != null) {
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref().child(images[index].path.toString());
      final StorageUploadTask task = firebaseStorageRef.putFile(images[index]);
      return Card(
        child: Column(
          children: <Widget>[
            /**
            Image.file(images[index], height: MediaQuery
                .of(context)
                .size
                .height / 1.5,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.5)
                */
            Image.file(images[index], height: 300.0, width: 300.0)
          ],
        ),
      );
    }
    else {
      return Card(
        child: Column(
          children: <Widget>[

          ],
        ),
      );
    }

  }

  ListView _buildImageList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: images.length,
      // A callback that will return a widget.
      itemBuilder: _buildImageItem,
    );
  }
}