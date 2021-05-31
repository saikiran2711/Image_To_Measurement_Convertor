import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MeasurementsScreen extends StatefulWidget {
  @override
  _MeasurementsScreenState createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  bool isDataLoaded = false;
  String imageURL = "";
  dynamic data = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero)
        .then((_) => {
              imageURL = ModalRoute.of(context)!.settings.arguments as String,
              getData(imageURL),
            })
        .catchError((err) => {
          print("Some thing went wrong !!")       
        });
  }

  Future<void> getData(imageURL) async {
    try {
      final res = await http.post(
          Uri.https("backend-test-zypher.herokuapp.com",
              "/uploadImageforMeasurement"),
          body: json.encode({
            "imageURL": imageURL,
          }));
      final resData = json.decode(res.body) as Map<String, dynamic>;

      setState(() {
        data = resData["d"];
        isDataLoaded = true;
      });
    } catch (err) {
      print("Error occured : " + err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: !isDataLoaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 6),
                Text("Loading..."),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/");
                      },
                      child: Text("Take Measurement Again")),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // padding: EdgeInsets.all(4),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    height: 500,
                    child: ListView(
                      children: [
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Neck"),
                            trailing: Text(data["neck"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Height"),
                            trailing: Text(data["height"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Weight"),
                            trailing: Text(data["weight"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Belly"),
                            trailing: Text(data["belly"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Chest"),
                            trailing: Text(data["chest"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Wrist"),
                            trailing: Text(data["wrist"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("ArmLength"),
                            trailing: Text(data["armLength"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Thigh"),
                            trailing: Text(data["thigh"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Shoulder"),
                            trailing: Text(data["shoulder"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Hips"),
                            trailing: Text(data["hips"].toString()),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text("Ankle"),
                            trailing: Text(data["ankle"].toString()),
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
