import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/RideDetails.dart';
import '../Notifications/notificationDialog.dart';
import '../configMaps.dart';
import '../main.dart';
import 'dart:io' show Platform;

class PushNtificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  var newId;

  Future initilaize(context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      retrieveRideRequistInfo(getRideRequistId(message.data), context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      retrieveRideRequistInfo(getRideRequistId(message.data), context);
    });
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print("this is the notofication token :::: ");
    print(token);
    dirversRef.child(currentfirebaseuser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequistId(Map<String, dynamic> message) {
    String rideRequistId;
    if (Platform.isAndroid) {
      rideRequistId = message['ride_requist_id'];
    } else {
      rideRequistId = message['ride_requist_id'];
    }
    return rideRequistId;
  }

  void retrieveRideRequistInfo(String reideRequestId, BuildContext context) {
    newRequistRef.child(reideRequestId).once().then((dataSnapshot) {
      print(reideRequestId);
      if (dataSnapshot.value != null) {
        assetsAudioplayer.open(Audio("sounds/alert.mp3"));
        assetsAudioplayer.play();
        double pickUpLatitude =
            double.parse(dataSnapshot.value['pickup']['latitude'].toString());
        double pickUpLongitude =
            double.parse(dataSnapshot.value['pickup']['longitude'].toString());
        String pickUpAddress = dataSnapshot.value['pickup_address'].toString();

        double dropOffLatitude =
            double.parse(dataSnapshot.value['dropoff']['latitude'].toString());
        double dropOffLongitude =
            double.parse(dataSnapshot.value['dropoff']['longitude'].toString());
        String dropOffAddress =
            dataSnapshot.value['droppOff_address'].toString();
        String paymentMethod = dataSnapshot.value['payment_method'].toString();

        String rider_name = dataSnapshot.value["rider_name"];
        String rider_phone = dataSnapshot.value["rider_phone"];

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_requist_id = reideRequestId;
        rideDetails.dropOff = LatLng(dropOffLatitude, dropOffLongitude);
        rideDetails.pickUp = LatLng(pickUpLatitude, pickUpLongitude);
        rideDetails.dropOff_address = dropOffAddress;
        rideDetails.pickUp_address = pickUpAddress;
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.rider_phone = rider_phone;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => NotificationDialog(rideDetails: rideDetails),
        );
      } else {
        print("Erorr*************************************************");
      }
    });
  }
}
