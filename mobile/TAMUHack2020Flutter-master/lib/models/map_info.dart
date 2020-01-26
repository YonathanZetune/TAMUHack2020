import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class MapInfo extends ChangeNotifier {
  static Set<Marker> _fireMarkers = Set();

  Set<Marker> get fireMarkers => _fireMarkers;

  set fireMarkers(Set<Marker> fires) {
    _fireMarkers = fires;
    notifyListeners();
  }






}
