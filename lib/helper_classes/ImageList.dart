import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class ImageList extends StatelessWidget {

  // Builder methods rely on a set of data, such as a list.
  final List<File> images;
  ImageList(this.images);

  @override
  Widget build(BuildContext context) {
    return _buildImageList(context);
  }

  Widget _buildImageItem(BuildContext context, int index) {
    if(images[index].path.toString() != null) {
      String filename = basename(images[index].path);
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref().child(filename);
      final StorageUploadTask task = firebaseStorageRef.putFile(images[index]);

      return Card(
        child: Column(
          children: <Widget>[
            new Image.file(images[index], fit: BoxFit.fill)
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