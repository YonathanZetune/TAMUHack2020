import 'package:flutter/material.dart';

class ReportList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Cases'),
      ),
      body: ListView.builder(
        itemBuilder: (context, position) {
          return Card(
            child: Container(
                height: 150,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 150,
                          child: Image(
                              image: AssetImage(
                                  'assets/list${position + 1}.jpg'))),
                    ),
                    Text(position % 2 == 0 ? "In progress" : "Submitted"),
                  ],
                )),
          );
        },
        itemCount: 4,
      ),
    );
  }
}
