import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Assistants/assistentMethods.dart';
import '../Assistants/mapKitAssestant.dart';
import '../Models/RideDetails.dart';
import '../allwidgets/CustomColors.dart';
import '../allwidgets/collectFareDialog.dart';
import '../allwidgets/progressDilog.dart';
import '../configMaps.dart';
import '../main.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;
  NewRideScreen({this.rideDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.015137, 28.979530),
    zoom: 14.4746,
  );
  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> _controllergoogleMap = Completer();

  GoogleMapController newRideGooglemapController;

  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> poyleSet = Set<Polyline>();

  List<LatLng> polylineCordinats = [];

  PolylinePoints polylinePoints = PolylinePoints();

  double mapPaddingFromBottom = 0;

  var geoLocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatingMarkerIcon;

  Position myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequistingDirection = false;

  String btnTitle = "The driver has arrived";
  Color btnColor = CostumColors.asfar_color;

  Timer timer;

  int durationCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    acceptRideRequist();
  }

  void creatIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/car_android.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getRideLiveLocationUpdate() {
    String rideRequistId = widget.rideDetails.ride_requist_id;
    LatLng oldPos = LatLng(0, 0);
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPos = position;
      myPosition = position;

      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, myPosition.latitude, myPosition.longitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPosition,
        icon: animatingMarkerIcon,
        rotation: rot,
        infoWindow: InfoWindow(title: "Your current location "),
      );

      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPosition, zoom: 17.0);
        newRideGooglemapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markersSet
            .removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });
      //
      oldPos = mPosition;
      updateRideDetails();
      Map locMap = {
        "latitude": currentPos.latitude.toString(),
        "longitude": currentPos.longitude.toString(),
      };
      newRequistRef.child(rideRequistId).child("driver_location").set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    creatIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: markersSet,
            circles: circleSet,
            polylines: poyleSet,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controllergoogleMap.complete(controller);
              newRideGooglemapController = controller;

              setState(() {
                mapPaddingFromBottom = 265.0;
              });
              var currentLatLng =
                  LatLng(currentPos.latitude, currentPos.longitude);
              var pickupLatLng = widget.rideDetails.pickUp;

              await getPlaceDirection(currentLatLng, pickupLatLng);

              getRideLiveLocationUpdate();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  color: CostumColors.petroly_color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ]),
              height: 260.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [
                    // time for km ,
                    Text(
                      durationRide,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Brand-bold",
                        color: CostumColors.asfar_color,
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.rideDetails.rider_name,
                          style: TextStyle(
                              fontFamily: "Brand-bold",
                              fontSize: 24.0,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("images/pickicon.png",
                            width: 16.0, height: 16.0),
                        SizedBox(width: 18.0),
                        Expanded(
                            child: Container(
                          // pick up adress ..
                          child: Text(
                            widget.rideDetails.pickUp_address,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("images/desticon.png",
                            width: 16.0, height: 16.0),
                        SizedBox(width: 18.0),
                        Expanded(
                            child: Container(
                          // place you going to ,
                          child: Text(
                            widget.rideDetails.dropOff_address,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () async {
                            if (status == "accepted") {
                              status = "arrived";
                              String rideRequistId =
                                  widget.rideDetails.ride_requist_id;
                              newRequistRef
                                  .child(rideRequistId)
                                  .child("status")
                                  .set(status);
                              setState(() {
                                btnTitle = "Start";
                                btnColor = Colors.green;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) => ProgressDialog(
                                        massage: "Please wait...",
                                      ),
                                  barrierDismissible: false);

                              await getPlaceDirection(widget.rideDetails.pickUp,
                                  widget.rideDetails.dropOff);
                              Navigator.pop(context);
                            } else if (status == "arrived") {
                              status = "onride";
                              String rideRequistId =
                                  widget.rideDetails.ride_requist_id;
                              newRequistRef
                                  .child(rideRequistId)
                                  .child("status")
                                  .set(status);
                              setState(() {
                                btnTitle = "Destination arrived,Finish";
                                btnColor = Colors.redAccent;
                              });
                              initTimer();
                            } else if (status == "onride") {
                              endTrop();
                            }
                          },
                          color: btnColor,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    btnTitle,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: CostumColors.petroly_color,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                  size: 26.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection(
      LatLng pickUpLanLng, LatLng dropOffLanLng) async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(massage: "Please wait..."),
    );

    var details = await AsisstentMethods.obtainDirectionDetails(
        pickUpLanLng, dropOffLanLng);

    Navigator.pop(context);
    print("this is encoded points :: ");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    polylineCordinats.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        // point add
        polylineCordinats
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    poyleSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("PolylineID"),
        color: Colors.pink,
        jointType: JointType.round,
        points: polylineCordinats,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      poyleSet.add(polyline);
    });

    // set the icons in the map

    LatLngBounds latLngBounds;
    if (pickUpLanLng.latitude > dropOffLanLng.latitude &&
        pickUpLanLng.longitude > dropOffLanLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLanLng, northeast: pickUpLanLng);
    } else if (pickUpLanLng.longitude > dropOffLanLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLanLng.latitude, dropOffLanLng.longitude),
          northeast: LatLng(dropOffLanLng.latitude, pickUpLanLng.longitude));
    } else if (pickUpLanLng.latitude > dropOffLanLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLanLng.latitude, pickUpLanLng.longitude),
          northeast: LatLng(pickUpLanLng.latitude, dropOffLanLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLanLng, northeast: dropOffLanLng);
    }

    newRideGooglemapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpMarker = Marker(
      markerId: MarkerId('PickupId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: pickUpLanLng,
    );
    Marker dropOffMarker = Marker(
      markerId: MarkerId('DropOffId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLanLng,
    );

    setState(() {
      markersSet.add(pickUpMarker);
      markersSet.add(dropOffMarker);
    });

    Circle pickUpCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLanLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );
    Circle dropOffCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLanLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("DropOffId"),
    );

    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }

  void acceptRideRequist() {
    String rideRequistId = widget.rideDetails.ride_requist_id;
    newRequistRef.child(rideRequistId).child("status").set("accepted");
    newRequistRef
        .child(rideRequistId)
        .child("driver_name")
        .set(driversInformation.name);
    newRequistRef
        .child(rideRequistId)
        .child("driver_phone")
        .set(driversInformation.phone);
    newRequistRef
        .child(rideRequistId)
        .child("driver_id")
        .set(driversInformation.id);
    newRequistRef.child(rideRequistId).child("car_details").set(
        '${driversInformation.car_color} - ${driversInformation.car_model} - ${driversInformation.car_number}');

    Map locMap = {
      "latitude": currentPos.latitude.toString(),
      "longitude": currentPos.longitude.toString(),
    };
    newRequistRef.child(rideRequistId).child("driver_location").set(locMap);

    dirversRef
        .child(currentfirebaseuser.uid)
        .child("history")
        .child(rideRequistId)
        .set("true");
  }

  void updateRideDetails() async {
    if (isRequistingDirection == false) {
      isRequistingDirection = true;

      if (myPosition == null) {
        return;
      }
      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;
      if (status == "accepted") {
        destinationLatLng = widget.rideDetails.pickUp;
      } else {
        destinationLatLng = widget.rideDetails.dropOff;
      }
      var directionDetails = await AsisstentMethods.obtainDirectionDetails(
          posLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.distanceText;
        });
        isRequistingDirection = false;
      }
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  void endTrop() async {
    timer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        massage: "please wait",
      ),
    );

    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

    var directionDetails = await AsisstentMethods.obtainDirectionDetails(
        widget.rideDetails.pickUp, currentLatLng);
    Navigator.pop(context);

    int fareAmount = AsisstentMethods.calculateFares(directionDetails);

    String rideRequistId = widget.rideDetails.ride_requist_id;
    newRequistRef
        .child(rideRequistId)
        .child("fares")
        .set(fareAmount.toString());
    newRequistRef.child(rideRequistId).child("status").set("ended");

    rideStreamSubscription.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CollectFareDialog(
        fareAmount: fareAmount,
        paymentMethod: widget.rideDetails.payment_method,
      ),
    );
    saveEarnings(fareAmount);
  }

  void saveEarnings(int fareAmount) {
    dirversRef
        .child(currentfirebaseuser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      //
      if (dataSnapshot.value != null) {
        double oldEarnings = double.parse(dataSnapshot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;
        dirversRef
            .child(currentfirebaseuser.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount.toDouble();

        dirversRef
            .child(currentfirebaseuser.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
