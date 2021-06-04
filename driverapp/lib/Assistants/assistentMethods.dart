import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Assistants/requestAssistants.dart';
import '../Models/directionDetails.dart';
import '../Models/hestoy.dart';
import '../configMaps.dart';
import '../dataHandler/appData.dart';
import '../main.dart';

class AsisstentMethods {
  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    var directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double distancTravledFare = (directionDetails.distanceValue / 1000) * 2.50;
    if (rideType != "") {
      if (rideType == "taxi") {
        double result = distancTravledFare * 2.0;
        return result.truncate();
      }
      if (rideType == "private car") {
        double result = distancTravledFare;
        return result.truncate();
      }
      if (rideType == "bike") {
        double result = distancTravledFare / 2;
        return result.truncate();
      }
    } else {
      double result = distancTravledFare;
      return result.truncate();
    }
  }

  static void desableHomeTabLiveLocationUpdate() {
    hometapPageStreamSubscription.pause();
    Geofire.removeLocation(currentfirebaseuser.uid);
  }

  static void enableHomeTabLiveLocationUpdate() {
    hometapPageStreamSubscription.resume();
    Geofire.setLocation(
        currentfirebaseuser.uid, currentPos.latitude, currentPos.longitude);
  }

  static void retrieveHistoryInfo(BuildContext context) {
    //retrive the earnings hestory ..
    dirversRef
        .child(currentfirebaseuser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    // retrive and display Trip hestory
    dirversRef
        .child(currentfirebaseuser.uid)
        .child("history")
        .once()
        .then((DataSnapshot datasnapshot) {
      if (datasnapshot.value != null) {
        Map<dynamic, dynamic> keys = datasnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripsCounters(tripCounter);

        List<String> tripHestoryKeys = [];

        keys.forEach((key, value) {
          tripHestoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHestoryKeys);
        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) async {
    var keys = Provider.of<AppData>(context, listen: false).trpHestorykeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance
          .reference()
          .child('RideRequests')
          .child(key);

      await historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = Hestory.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updatedHistoryTripData(history);
        }
      });
    }
  }

  static fromTripDate(String date) {
    //
    DateTime dateTime = DateTime.parse(date);
    String formateddate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formateddate;
  }
}
