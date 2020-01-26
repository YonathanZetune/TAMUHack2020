import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamu_hack_2020/frontend/list_page.dart';
import 'package:tamu_hack_2020/frontend/report_page.dart';
import 'package:tamu_hack_2020/models/form_info.dart';

import 'frontend/home_page.dart';
import 'utilities/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      initialRoute: '/',
      routes: {
        // When we navigate to the "/" route, build the MapView Screen
        '/ReportPage': (context) => ChangeNotifierProvider(
            create: (context) => FormInfo(), child: ReportPage()),
        '/ReportList': (context) => new ReportList(),
      },
      theme: ThemeData(
        primaryColor: Colors.red[600],
      ),
      home: MyHome(),
    );
  }
}
