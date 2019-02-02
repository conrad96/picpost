import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

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

class _MyHomePageState extends State<MyHomePage>
{
  File _image;

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(imageFile);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final title = "file";
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 600);
    var compressImg = new File("$path/image_$title.jpg").writeAsBytesSync(Img.encodeJpg(smallerImg,quality: 90));
    
    setState(() {
      _image = imageFile;
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    print(imageFile);
    setState(() {
      _image = imageFile;
    });
  }

  Future uploadImageFile(File image) async
  {
    var upstream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse("http://192.168.1.5/picpost/upload.php");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile("image",upstream,length,filename: basename(image.path));

    var cTitle;
    request.fields['title'] = cTitle.text;

    request.files.add(multipartFile);

    var response = await request.send();
    if(response.statusCode == 200)
      {
        print("Image uploaded");
      }else{
      print("Image uploaded Failed");
    }

  }

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image"),),
      body: Column(
        children: <Widget>[
          _image == null ? new Text("No image selected") : new Image.file(_image),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.image),
                onPressed: getImageGallery,
              ),

              RaisedButton(
                child: Icon(Icons.camera_alt),
                onPressed: getImageCamera,
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.file_upload),
                        ),
                        // ignore: argument_type_not_assignable
                        onPressed: (){
                          uploadImageFile(_image);
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}