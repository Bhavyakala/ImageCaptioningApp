import 'dart:convert';
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
  bool _showFutureBuilderWidget = false;
  final picker = ImagePicker();

  _getImage(ImageSource imageSource) async {

    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<dynamic> _apiCall() async {
    var captionObj = CaptionApi();
    var res = await captionObj.uploadImage(_image);
    return res;
  }
  
  Widget _buildApiCall(File _image) {
    return Container(
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.done) {
            if(snapshot.hasError) {
              return Text("${snapshot.error} occured",style: TextStyle(fontSize: 15.0));
            } else if (snapshot.hasData) {

              String caption = snapshot.data["description"];
              caption = caption.toUpperCase();
              return 
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), 
                      child:
                      Text('$caption', style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    )
                  ],
                );
            } 
          }
          return Center(
            child : CircularProgressIndicator()
          );
       },
       future: _apiCall(),
      ),
    );
  }
  

  Widget _buildImage() {
    if(_image!=null) {
      return Image.file(
        _image,
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fitWidth
      );
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
          if(_image!=null)
            Expanded (child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState((){
                        _image=null;
                        _showFutureBuilderWidget=false;
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
              ])
            ),
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
        Expanded(child: Padding(padding: EdgeInsets.all(8.0), child: Center(child:_buildImage()))),
        if(_showFutureBuilderWidget==true)
          _buildApiCall(_image),
        if(_image!=null)
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: ()=> setState((){
                    _showFutureBuilderWidget=true;
                  }), 
                  child: Text("Get Caption"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    shadowColor: Colors.black,
                  ),
                )
              ],
            ),
          ),
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