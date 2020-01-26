import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';
import 'package:tamu_hack_2020/models/form_info.dart';
import 'package:tamu_hack_2020/models/map_info.dart';
import 'package:tamu_hack_2020/widgets/danger_fab.dart';
import 'package:tamu_hack_2020/widgets/home_fab.dart';
import 'package:tamu_hack_2020/widgets/map_view.dart';
import 'package:tamu_hack_2020/widgets/refresh_fab.dart';

class MyHome extends StatelessWidget {
  static List<TabItem> tabs = new List<TabItem>();

  @override
  Widget build(BuildContext context) {
    tabs = new List<TabItem>();
    tabs.add(TabItem(title: "Map", icon: Icons.map));
    tabs.add(TabItem(title: "Report", icon: Icons.add_location));
    tabs.add(TabItem(title: "List", icon: Icons.list));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapInfo()),
        ChangeNotifierProvider(create: (context) => FormInfo())
      ],
      child: Container(
        child: Scaffold(
          bottomNavigationBar: ConvexAppBar(
            onTap: (ind) {
              switch (ind) {
                case 0:
                  Navigator.of(context).canPop()
                      ? Navigator.of(context).popAndPushNamed('/')
                      : print('cant push');
                  break;
                case 1:
                  Navigator.of(context).pushNamed('/ReportPage');
                  break;
                case 2:
                  //Navigator.of(context).canPop()
                       Navigator.of(context).pushNamed('/ReportList');
                     // : print('cant push');
                  break;
              }
            },
            items: tabs,
            backgroundColor: Colors.red[600],
            style: TabStyle.fixedCircle,
          ),
//          appBar: AppBar(
//            backgroundColor: Colors.deepOrange,
//          ),
          body: Stack(
            children: <Widget>[
              MapView(),
              HomeFAB(),
              RefreshFAB(),
              DangerFAB(),
            ],
          ),
        ),
      ),
    );
  }
}
