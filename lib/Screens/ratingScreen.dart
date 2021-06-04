import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sonbitirmeprojesi/myColors/MyColors.dart';

import '../configmaps.dart';

class RatingScrean extends StatefulWidget {
  final String driverId;
  RatingScrean({this.driverId});

  @override
  _RatingScreanState createState() => _RatingScreanState();
}

class _RatingScreanState extends State<RatingScrean> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColors.petroly_color,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0),
              Text(
                "rate the driver",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white60,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 22.0),
              Divider(height: 2.0, thickness: 2.0),
              SizedBox(height: 22.0),
              SmoothStarRating(
                borderColor: MyColors.asfar_color,
                rating: starCounter,
                color: MyColors.asfar_color,
                allowHalfRating: false,
                starCount: 5,
                size: 45,
                onRated: (rating) {
                  starCounter = rating;
                  if (starCounter == 1) {
                    setState(() {
                      title = "very bad";
                    });
                  }
                  if (starCounter == 2) {
                    setState(() {
                      title = "bad";
                    });
                  }
                  if (starCounter == 3) {
                    setState(() {
                      title = "good";
                    });
                  }
                  if (starCounter == 4) {
                    setState(() {
                      title = "very good";
                    });
                  }
                  if (starCounter == 5) {
                    setState(() {
                      title = "excellent";
                    });
                  }
                },
              ),
              SizedBox(height: 14.0),
              Text(
                title,
                style: TextStyle(fontSize: 20.0, color: Colors.white60),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.all(12.0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: () async {
                    DatabaseReference driversRatingRef = FirebaseDatabase
                        .instance
                        .reference()
                        .child("drivers")
                        .child(widget.driverId)
                        .child("ratings");

                    driversRatingRef.once().then((snap) {
                      if (snap.value != null) {
                        double oldratings = double.parse(snap.value.toString());
                        double addRatings = oldratings + starCounter;
                        double averageRating = addRatings / 2;
                        driversRatingRef.set(averageRating.toString());
                      } else {
                        driversRatingRef.set(starCounter.toString());
                      }
                    });
                    Navigator.pop(
                      context,
                    );
                  },
                  color: MyColors.asfar_color,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: MyColors.petroly_color,
                          size: 26.0,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "confirm",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: MyColors.petroly_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
