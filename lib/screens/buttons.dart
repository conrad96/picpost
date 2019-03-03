import 'package:flutter/material.dart';
import 'package:picpost/screens/home.dart';

class Buttons
{
  Widget galleryButton()
  {
    return RaisedButton(
      child: Icon(Icons.image),

    );
  }
  Widget cameraButton()
  {
    return RaisedButton(
      child: Icon(Icons.file_upload),
      onPressed: (){

      },
    );
  }
}
