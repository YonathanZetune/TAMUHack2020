import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamu_hack_2020/models/map_info.dart';
import 'package:tamu_hack_2020/utilities/requests.dart';
import 'package:tamu_hack_2020/widgets/map_view.dart';
import 'package:toast/toast.dart';

class DangerFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<MapInfo>(context, listen: false);

    return Positioned(
      top: 60,
      left: 20,
      child: FloatingActionButton(
        heroTag: "danFAB1",
        backgroundColor: Colors.white,

        child: Image(image: AssetImage('assets/logo512.png')),
        //Icon(Icons.cloud,color: Colors.red[600], size: 35.0),
        tooltip: "Are you in an area of risk?",
        onPressed: () async {
          Toast.show("You are not in an area of high risk", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          // TODO: implement return to home functionality
        },
      ),
    );
  }
}
