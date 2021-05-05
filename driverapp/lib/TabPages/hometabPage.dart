import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../Assistants/assistentMethods.dart';
import '../Models/drivers.dart';
import '../Notifications/pushNotificationSirvce.dart';
import '../allwidgets/CustomColors.dart';
import '../configMaps.dart';
import '../dataHandler/appData.dart';
import '../main.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.015137, 28.979530),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  double bottumpaddingofMap = 0;

  String driverStatusText = "خارج الخدمة";

  Color driverStatusColor = Colors.black;

  bool isDraiverAvailable = false;

  List<LatLng> pLineCoerordinates = [];

  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};

  Set<Circle> circlesSet = {};

  Completer<GoogleMapController> _controllergoogleMap = Completer();

  GoogleMapController newGooglemapController;

  bool changecolor = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentDriverInfo();
  }

  getRideType() {
    dirversRef
        .child(currentfirebaseuser.uid)
        .child("car_details")
        .child("type")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        setState(() {
          rideType = dataSnapshot.value.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Google map ...
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllergoogleMap.complete(controller);
            newGooglemapController = controller;

            locatePosition();
          },
        ),
        // online off line panle ...

        Container(
          height: 220.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            color: CostumColors.petroly_color.withOpacity(0.8),
          ),
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (isDraiverAvailable != true) {
                    makeDriverOnlineNow();
                    getLocationLiveUpdates();
                    setState(() {
                      // driverStatusColor = Colors.green;
                      driverStatusText = "في الخدمة";
                      isDraiverAvailable = true;
                    });
                    Fluttertoast.showToast(
                        msg: "انت في الخدمة الان", textColor: Colors.green);
                  } else {
                    makeDriverOffline();
                    setState(() {
                      driverStatusColor = Colors.black;
                      driverStatusText = " خارج الخدمة";
                      isDraiverAvailable = false;
                    });

                    displayToastMsg("انت خارج الخدمة الان ", context);
                  }
                  setState(() {
                    changecolor = !changecolor;
                  });
                },
                child: CircleAvatar(
                  backgroundColor: CostumColors.asfar_color,
                  maxRadius: 35,
                  minRadius: 35,
                  child: Icon(
                    Icons.power_settings_new,
                    size: 55,
                    color: changecolor ? Colors.green : Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                driverStatusText,
                style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPos = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGooglemapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPos = position;
    // Geofire.initialize("availableDrivers");
    // Geofire.setLocation(
    //     currentfirebaseuser.uid, currentPos.latitude, currentPos.longitude);

    // rideRequistRef.set("searching");
    // rideRequistRef.onValue.listen((event) {
    //   //
    // });
  }

  void makeDriverOffline() {
    //  Geofire.removeLocation(currentfirebaseuser.uid);

    if (rideRequistRef != null) {
      rideRequistRef.onDisconnect();
      rideRequistRef.remove();
    } else {
      print("thie rider states is null");
    }
  }

  void getLocationLiveUpdates() {
    hometapPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPos = position;
      // if (isDraiverAvailable == true) {
      //   Geofire.setLocation(
      //       currentfirebaseuser.uid, position.latitude, position.longitude);
      // }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGooglemapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.red);
  }

  void getCurrentDriverInfo() async {
    currentfirebaseuser = FirebaseAuth.instance.currentUser;

    dirversRef
        .child(currentfirebaseuser.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        driversInformation = Drivers.fromSnapShot(dataSnapshot);
      }
    });
    // //PushNtificationService pushntificationService = PushNtificationService();
    // pushntificationService.initilaize(context);
    // pushntificationService.getToken();
    // setState(() {
    //   if (Provider.of<AppData>(context, listen: false).tripHestoryDetailsList !=
    //       null) {
    //     Provider.of<AppData>(context, listen: false).clearHestory();
    //   }
    // });

    AsisstentMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  getRatings() {
    dirversRef
        .child(currentfirebaseuser.uid)
        .child("ratings")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double ratings = double.parse(snapshot.value.toString());

        setState(() {
          starCounter = ratings;
        });
        if (starCounter <= 1) {
          setState(() {
            title = "Very bad";
          });
          return;
        }
        if (starCounter <= 2) {
          setState(() {
            title = "bad";
          });
          return;
        }
        if (starCounter <= 3) {
          setState(() {
            title = "good";
          });
          return;
        }
        if (starCounter <= 4) {
          setState(() {
            title = "Very good";
          });
          return;
        }
        if (starCounter >= 5) {
          setState(() {
            title = "Excellent";
          });
          return;
        }
      }
    });
  }
}
