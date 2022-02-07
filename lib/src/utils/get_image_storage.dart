import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/utils/image.dart';

class GetImageAvtStorage extends StatefulWidget {
  String nameImage;

  GetImageAvtStorage(this.nameImage);

  @override
  _GetImageAvtStorageState createState() => _GetImageAvtStorageState();
}

class _GetImageAvtStorageState extends State<GetImageAvtStorage> {

  Uint8List imageFile;
  StorageReference photoReference = storage.ref();

  getImage(){
    int MAX_SIZE = 4*1024*1024;

    photoReference.child(widget.nameImage).getData(MAX_SIZE).then((data){
      this.setState(() {
        imageFile = data;
      });
    }).catchError((err){
      print(err);
    });
  }

  Widget decideGridTileWidget(){
    if(imageFile == null){
      return Image.asset(imageAvatar, fit: BoxFit.cover,);
    }else{
      return Image.memory(imageFile, fit: BoxFit.cover,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return decideGridTileWidget();
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

}
