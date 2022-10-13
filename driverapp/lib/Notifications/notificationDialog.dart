import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Assistants/assistentMethods.dart';
import '../Models/RideDetails.dart';
import '../allScreen/newRideScreen.dart';
import '../allwidgets/CustomColors.dart';
import '../main.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: CostumColors.petroly_color,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CostumColors.petroly_color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0),
            Image.asset("images/cars/skoda.png", width: 250.0),
            SizedBox(height: 18.0),
            Text("New Requist",
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png",
                          height: 16.0, width: 16.0),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.pickUp_address,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png",
                          height: 16.0, width: 16.0),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.dropOff_address,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Divider(),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: deprecated_member_use
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      // assetsAudioplayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "deny".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  // ignore: deprecated_member_use
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green),
                    ),
                    color: Colors.white,
                    textColor: Colors.green,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      // assetsAudioplayer.stop();
                      //   Navigator.pop(context);
                      checkAviliblityOfRide(context);
                    },
                    child: Text(
                      "accept".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void checkAviliblityOfRide(BuildContext context) {
    rideRequistRef.once().then((DataSnapshot dataSnapshot) {
      Navigator.pop(context);
      String theRideId = "";
      if (dataSnapshot.value != null) {
        theRideId = dataSnapshot.value.toString();
      } else {
        displayToastMsg("no ride exists", context);
      }
      if (theRideId == rideDetails.ride_requist_id) {
        rideRequistRef.set("accepted");
        AsisstentMethods.desableHomeTabLiveLocationUpdate();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewRideScreen(rideDetails: rideDetails),
            ));
      } else if (theRideId == "cancelled") {
        displayToastMsg("the rider has cancelled exists", context);
      } else if (theRideId == "timeout") {
        displayToastMsg("ride has timeout ", context);
      } else {
        displayToastMsg("ride not exisites ", context);
      }
    });
  }

  void displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.red);
  }
}
