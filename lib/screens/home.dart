import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:picpost/screens/buttons.dart';
import '../main.dart';

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicPost',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  _MyHomePageState createState() => _MyHomePageState();

}


class ServerResponse{
  String text_response;
  ServerResponse({ this.text_response });

  factory ServerResponse.fromJson(Map<String, dynamic> parsedJson)
  {
    return ServerResponse(
      text_response: parsedJson['value']
    );
  }

}

class _MyHomePageState extends State<MyHomePage>
{
  File _image;
  var _result;
  var _path;
  var ipAddress = "http://192.168.1.5/mobile/support/upload.php";

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(imageFile);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final title = "file";
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 600);
    //var compressImg = new File("$path/image_$title.jpg").writeAsBytesSync(Img.encodeJpg(smallerImg,quality: 90));
    
    setState(() {
      _image = imageFile;
      _path = tempDir.path;
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    print(imageFile);
    setState(() {
      _image = imageFile;
      _path = ImageSource.camera;
    });
  }

  Future uploadImageFile(File image) async
  {
    Dio dio = new Dio();
    FormData formdata = new FormData.from({
      "upload": "upload",
      "photo": new UploadFileInfo(_image, "upload_image")
    }) ;
    var response = await dio.post(ipAddress, data: formdata).then((response)=>print(response)).catchError((error) => print(error));

  }

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text("PIC POST"),
      ),
      body: new ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.image),
                onPressed: (){
                  getImageGallery();
                },
              ),

              RaisedButton(
                child: Icon(Icons.camera_alt),
                onPressed: (){
                  getImageCamera();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _image == null ? const Text("No Photo Selected") : new Image.file(_image)
            ],
          )
        ],
      )
    );
  }
}
