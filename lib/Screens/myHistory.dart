import 'package:flutter/material.dart';

class MyHistory extends StatefulWidget {
  static const String screenId = "MyHistory";

  @override
  _MyHistoryState createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("My HESTORY "),
      ),
    );
  }
}
