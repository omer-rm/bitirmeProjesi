import 'dart:convert';
import 'dart:math';

import '../Assistants/requestAssistant.dart';
import '../DataHandler/appData.dart';
import '../Models/address.dart';
import '../Models/allUsers.dart';
import '../Models/directionDetails.dart';
import '../configmaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    var url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickupAddress = new Address();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
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
    double acilisUcreti = 4.00;
    double kiloMitreBasina = 3.00;

    double distancTravledFare =
        ((directionDetails.distanceValue / 1000) * kiloMitreBasina) +
            (acilisUcreti);

    double totalFareAmount = distancTravledFare;

    return totalFareAmount.truncate();
  }

  static void getallUserInfo() async {
    firebaseUsers = FirebaseAuth.instance.currentUser;
    String userId = firebaseUsers.uid;

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        usersCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }

  static double creatRandomNumber(int number) {
    var random = Random();
    int randomNum = random.nextInt(number);
    return randomNum.toDouble();
  }

  static sendNotificationToDriver(
      String token, context, String ride_requist_id) async {
    var destination =
        Provider.of<AppData>(context, listen: false).dropOffLocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };
    Map notificationMap = {
      'body': 'DropOff Addess , ${destination.placeName}',
      'title': 'New Ride Requist'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_requist_id': ride_requist_id,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerMap, body: jsonEncode(sendNotificationMap));
  }
}
