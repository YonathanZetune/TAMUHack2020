import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamu_hack_2020/models/map_info.dart';
import 'package:tamu_hack_2020/utilities/requests.dart';
import 'package:tamu_hack_2020/widgets/map_view.dart';

class RefreshFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<MapInfo>(context, listen: false);

    return Positioned(
      bottom: 30,
      left: 20,
      child: FloatingActionButton(
        heroTag: "refFAB1",
        backgroundColor: Colors.white,
        child: Icon(
          Icons.refresh,
          size: 35.0,
          color: Colors.red[600],
        ),
        tooltip: "Refresh markers",
        onPressed: () async {
          // TODO: implement return to home functionality

          MapView.setFireMarkers(await Requests.getFires(),
              context); // = MapView.//await Requests.getFires();
        },
      ),
    );
  }
}
