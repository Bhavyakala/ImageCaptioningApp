import 'dart:io';
import 'package:application/CaptionApi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Caption Generator',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Colors.white,
      ),
      home: ImageCaptioner(),
    );
  }
}


class ImageCaptioner extends StatefulWidget {
  @override  
  _ImageCaptionerState createState() => _ImageCaptionerState();
}

class _ImageCaptionerState extends State<ImageCaptioner> {

  var _image;
  // var resJson;
  final picker = ImagePicker();

  _getImage(ImageSource imageSource) async {

    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  _apiCall() async {
    var captionObj = CaptionApi();
    var res = await captionObj.uploadImage(_image);
    var res1 = captionObj.getResponse();
    print(res1);
  }
  
  Widget _buildImage() {
    if(_image!=null) {
      _apiCall();
      return Image.file(_image);
    } else {
      return Text("Select an Image", style:  TextStyle(fontSize: 20.0));
    }
  }


  Widget _buildButtons() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 100.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: TextButton.icon(
              onPressed: () => _getImage(ImageSource.camera), 
              icon: Icon(Icons.camera_alt), 
              label: Text("Camera"),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder()
              ),
            )
          ),
          VerticalDivider(thickness: 2.0, color: Colors.black, width: 1.0),
          _image!=null? Expanded (child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState((){
                      _image=null;
                    }), 
                    child: Text("Clear"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder()
                    ),
                  )
                ),
                VerticalDivider(thickness: 2.0, color: Colors.black, width: 1.0),
            ])):Container(),
          Expanded(
            child: TextButton.icon(
              onPressed: () => _getImage(ImageSource.gallery), 
              icon: Icon(Icons.image), 
              label: Text("Gallery"),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder()
              ),
            )
          ),
        ],
      ),
    );
  } 
  
  Widget _imagePicker(BuildContext context) {
    return Column(
      children: <Widget>[
         Expanded(child: Padding(padding: EdgeInsets.all(8.0), child:Center(child: _buildImage()))),
        _buildButtons(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Image Caption Generator'),
      ),
      body: _imagePicker(context),
    );
  }
}