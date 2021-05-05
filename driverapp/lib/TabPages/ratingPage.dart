import 'package:flutter/material.dart';
import '../allwidgets/CustomColors.dart';

import '../configMaps.dart';

class RatingTabPage extends StatefulWidget {
  @override
  _RatingTabPageState createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CostumColors.petroly_color,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 200.0),
            Text(
              "My Rates",
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            // SmoothStarRating(
            //   borderColor: CostumColors.asfar_color,
            //   isReadOnly: true,
            //   rating: starCounter,
            //   color: CostumColors.asfar_color,
            //   allowHalfRating: true,
            //   starCount: 5,
            //   size: 45,
            // ),
            SizedBox(height: 14.0),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Brand-bold",
                  color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 1,
              decoration: BoxDecoration(color: Colors.black, boxShadow: [
                BoxShadow(
                    blurRadius: 3,
                    offset: Offset(0.0, 3),
                    spreadRadius: 0.1,
                    color: Colors.black87),
              ]),
            ),
          ],
        ));
  }
}
