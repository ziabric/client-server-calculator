import 'package:flutter/material.dart';
import 'Settings.dart';

class ShowAllWindow extends StatefulWidget {
  const ShowAllWindow({super.key});

  @override
  ShowAllWindowState createState() => ShowAllWindowState();
}

class ShowAllWindowState extends State<ShowAllWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: showAllData.length,
          itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              height: 60,
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
              child: Text(showAllData[index],
                  style: const TextStyle(fontSize: 20)))),
    );
  }
}
