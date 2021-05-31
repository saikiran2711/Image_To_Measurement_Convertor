import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'screens/measurementscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.white,
        primaryColor: Colors.white,
      ),
      // home: MyHomePage(),
      initialRoute: "/",
      routes: {
        "/": (ctx) => MyHomePage(),
        "/get-measurements": (ctx) => MeasurementsScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isImage = false;
  bool isUploading = false;
  String _imageUrl = "";
  final _image = new ImagePicker();
  File _imageFile = new File("");

  Future<void> clickImage() async {
    final pickedFile = await _image.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile!.path);
      isImage = true;
    });
  }

  Future<void> selectImage() async {
    final pickedFile = await _image.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
      isImage = true;
    });
  }

  Future<String> uploadImage() async {
    setState(() {
      isUploading = true;
    });
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('imageUrl');
    TaskSnapshot addImg = await firebaseStorageRef.putFile(_imageFile);
    if (addImg.state == TaskState.success) {
      _imageUrl = await addImg.ref.getDownloadURL();
      return _imageUrl;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Upload Image",
            style: TextStyle(fontSize: 32, color: Colors.blue)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Card(
                elevation: 6,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: !isImage
                    ? Center(child: Text("Please select a image..."))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.file(
                          _imageFile,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                    ),
                    onPressed: () async {
                      await clickImage();
                    },
                    child: Text(
                      "Click Photo",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                  ),
                  onPressed: () async {
                    await selectImage();
                  },
                  child: Text(
                    "Pick Image ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.pinkAccent),
                      elevation: MaterialStateProperty.all(5),
                    ),
                    onPressed: !isImage
                        ? null
                        : () async {
                            final String imageUrl = await uploadImage();

                            Navigator.of(context).pushReplacementNamed(
                                "/get-measurements",
                                arguments: imageUrl);
                          },
                    child: Text(
                      "Upload image",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
