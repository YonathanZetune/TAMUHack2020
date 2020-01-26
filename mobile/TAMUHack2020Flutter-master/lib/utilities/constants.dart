import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  //strings
  static const appName = "Brush";
  static const breezeAPIKey = "6b16e1d42b454f6b8dfb371dfb46d462";
  static const gMapsAPIKey = "AIzaSyBlqx2h7ABscfQSz-3MeYPzdWU1EfBJjgg";

  //Lists
//  static const tabs = List(TabItem(icon: Icons.home));

  //numbers
  static const breezeRadius = 60;
  static const startLat = -35.852522;
  static const startLong = 149.949387;

  //other
  static const CameraPosition defaultPosition = CameraPosition(
      target: LatLng(startLat, startLong), bearing: 270, zoom: 10.0, tilt: 0);


}