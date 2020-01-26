import 'dart:convert';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tamu_hack_2020/models/fire.dart';
import 'package:tamu_hack_2020/models/map_info.dart';
import 'package:tamu_hack_2020/utilities/constants.dart';

class Requests {
  static Future<List<Fire>> getFires() async {
    var path =
        "fires/v1/current-conditions?lat=${Constants.startLat}&lon=${Constants.startLong}&key=${Constants.breezeAPIKey}&radius=${Constants.breezeRadius}&units=imperial";
    var result = await getResult(path);
    print(result.toString());
    var fireList = FireList.fromJson(result).fires;
    return fireList;
  }

//  static Future<int> getWindDirection() async {
//    var path =
//        "https://api.breezometer.com/weather/v1/current-conditions?lat=${Constants.startLat}&lon=${Constants.startLong}&key=${Constants.breezeAPIKey}";
//    var result = await getResult(path);
//    print(result.toString());
//    var fireList = FireList.fromJson(result).fires;
//    return fireList;
//  }

  static Future<String> getImageProperties(File img) async {
    File imageFile = img;
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final ImageLabeler cloudLabeler =
        FirebaseVision.instance.cloudImageLabeler();
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> cloudLabels =
        await cloudLabeler.processImage(visionImage);
    for (ImageLabel label in cloudLabels) {
      print(label.text);
      return label.text;
    }
    cloudLabeler.close();
    labeler.close();
  }

  static Future<dynamic> getResult(String path) async {
    String requestUrl = 'https://api.breezometer.com/$path';
    var request = await HttpClient().getUrl(Uri.parse(requestUrl));
    var response = await request.close();
    var contents =
        await response.transform(utf8.decoder).transform(json.decoder).single;
    return contents;
  }

  static Future<dynamic> getFAPIResult(String path) async {
    String requestUrl = 'https://gentle-reef-37448.herokuapp.com/$path';
    var request = await HttpClient().getUrl(Uri.parse(requestUrl));
    var response = await request.close();
    var contents =
        await response.transform(utf8.decoder).transform(json.decoder).single;
    return contents;
  }

  static Future<int> postFAPIAnimal(double lat, double lon, String species) async {
    String url = 'https://gentle-reef-37448.herokuapp.com/animals/';
    Map<String, dynamic> jsonMap = {
      "lat": lat,
      "lg": lon,
      "species": species,
      "endangered": 0,
      "status": 0,
      "animalID": "string"
    };
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(jsonMap); // encode map to json
    print("HERE");
    await post(url, headers: headers, body: jsonString).then((response) {
      int statusCode = response.statusCode;
      String body = response.body;
      print(body + statusCode.toString());
      return statusCode;
    });
  }
}
