import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamu_hack_2020/models/fire.dart';
import 'package:tamu_hack_2020/models/map_info.dart';
import 'package:tamu_hack_2020/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatelessWidget {
  static final Completer<GoogleMapController> mController = Completer();

  static _openMap(double lat, double lon) async {
    var url = 'https://www.google.com/maps/dir/?api=1&origin=Sydney+Australia&destination=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false,);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> setFireMarkers(
      List<Fire> fires, BuildContext context) async {
    var mapInfo = Provider.of<MapInfo>(context, listen: false);
    Set<Marker> newMarkers = Set<Marker>();
    int markerID = 0;
    for (Fire fire in fires) {
      markerID++;
      final ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context);
      BitmapDescriptor myIcon = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/fire_96.png');
      newMarkers.add(Marker(
          markerId: MarkerId('STOP:' + markerID.toString()),
          flat: false,
          infoWindow: InfoWindow(
              title: "Intensity: " + fire.confidence,
              snippet: 'Press to get directions',
              onTap: () {
                // TODO: open google maps
                _openMap(fire.lat, fire.lon);

              }),
          icon: myIcon,
          position: LatLng(fire.lat, fire.lon)));
    }
    mapInfo.fireMarkers = newMarkers;
//    print("Markers updated" + newMarkers.toString());
  }

  static Future<void> goToHome(BuildContext context) async {
    final GoogleMapController controller = await mController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(Constants.defaultPosition));
  }

  @override
  Widget build(BuildContext context) {
    var mapInfo = Provider.of<MapInfo>(context);

    return Container(
      height: MediaQuery.of(context).size.height - 0,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        initialCameraPosition: Constants.defaultPosition,
        markers: mapInfo.fireMarkers,
        // TODO: addmarkers
        onMapCreated: (GoogleMapController controller) async {
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          controller.setMapStyle(mapInfo.mapStyle);
          mController.complete(controller);
        },
      ),
    );
  }
}
