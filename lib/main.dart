import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Upload MySQL',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> getImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> upload(File imageFile) async {
    var stream = http.ByteStream(imageFile.openRead().cast());
    var length = await imageFile.length();
    var uri = Uri.parse("http://localhost/survey_pelanggan/upload.php");

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Survey uploaded");
    } else {
      print("Survey upload failed with status: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: _imageFile == null
                ? Text("No image selected!")
                : Image.file(_imageFile!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Icon(Icons.image),
                onPressed: getImageGallery,
              ),
              SizedBox(width: 20),
              ElevatedButton(
                child: Icon(Icons.camera_alt),
                onPressed: getImageCamera,
              ),
              Expanded(
                child: Container(),
              ),
              ElevatedButton(
                child: Text("Send Survey"),
                onPressed: () async {
                  if (_imageFile != null) {
                    await upload(_imageFile!);
                  } else {
                    print("No image selected to upload");
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
