import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../allScreen/LginScreen.dart';
import '../allwidgets/CustomColors.dart';

import '../configMaps.dart';
import '../main.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            driversInformation.name,
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Brand-bold"),
          ),
          Text(
            title + "Driver",
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Brand-bold"),
          ),
          SizedBox(
            height: 20.0,
            width: 200.0,
            child: Divider(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
          buildTheCard(driversInformation.phone, Icons.phone_android),
          Divider(height: 30, thickness: 1.0),
          buildTheCard(driversInformation.email, Icons.email),
          Divider(height: 30, thickness: 1.0),
          buildTheCard(
              "${driversInformation.car_color} - ${driversInformation.car_model} - ${driversInformation.car_number}",
              Icons.local_taxi),
          Divider(height: 30, thickness: 1.0),
          SizedBox(height: 50),
          FlatButton(
            autofocus: true,
            onPressed: () async {
              //                          *mohhem*
              //    await Geofire.removeLocation(currentfirebaseuser.uid);
              rideRequistRef.onDisconnect();
              rideRequistRef.remove();
              rideRequistRef = null;
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.idScreen, (route) => false);
            },
            child: Text(
              "      Exit      ",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50.0),
            ),
            color: CostumColors.petroly_color,
          ),
        ],
      )),
    );
  }

  buildTheCard(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            icon,
            size: 25,
          ),
        ),
      ],
    );
  }
}
