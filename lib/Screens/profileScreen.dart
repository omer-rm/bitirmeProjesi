import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenId = "pscreen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("My PROFILE "),
      ),
    );
  }
}
