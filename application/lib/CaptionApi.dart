import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
class CaptionApi {

  var url = "http://192.168.29.117:8000/image_upload/";
  var responseString, responseStatusCode, resJson; 
  uploadImage(File _image) async {
    
    var req = http.MultipartRequest('POST',Uri.parse(this.url));

    var pic = await http.MultipartFile.fromPath("image", _image.path);
    req.files.add(pic);
    
    var res = await req.send();
    var responseData = await res.stream.toBytes();
    responseStatusCode = res.statusCode;
    responseString = String.fromCharCodes(responseData);
    resJson = json.decode(responseString);
    resJson["responseStatusCode"] = responseStatusCode;
    
    // print(responseString);
    // print(responseStatusCode);

    return resJson;
  }

}