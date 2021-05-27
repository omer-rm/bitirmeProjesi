import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sonbitirmeprojesi/AllWidgets/noDriverAvailableDialog.dart';
import 'package:sonbitirmeprojesi/Assistants/geofireAssestent.dart';
import 'package:sonbitirmeprojesi/Models/nearByAvailbleDrivers.dart';
import 'package:sonbitirmeprojesi/main.dart';
import '../AllWidgets/divider.dart';
import '../AllWidgets/progressDialog.dart';
import '../Assistants/assistantMethods.dart';
import '../DataHandler/appData.dart';
import '../Models/directionDetails.dart';
import '../Screens/loginScreen.dart';
import '../Screens/myHistory.dart';
import '../Screens/profileScreen.dart';
import '../Screens/searchScreen.dart';
import '../configmaps.dart';
import '../myColors/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String screenId = "mainScrreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool nearByAvailableDriverskeysLoaded = false;
  // Start ...
  @override
  initState() {
    super.initState();
    // Add listeners to this class
    AssistantMethods.getallUserInfo();
  }

  BitmapDescriptor nearByIcon;
  String state = "normal";
  DatabaseReference rideRequistRef;
  String uName = "";
  void saveRideRequist() {
    rideRequistRef =
        FirebaseDatabase.instance.reference().child("RideRequests").push();
    var pickup = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickup.latitude.toString(),
      "longitude": pickup.longitude.toString(),
    };
    Map dropOffLocMap = {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };
    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": usersCurrentInfo.name,
      "rider_phone": usersCurrentInfo.phone,
      "pickup_address": pickup.placeName,
      "droppOff_address": dropOff.placeName,
      "ride_type": carRideType,
    };
    rideRequistRef.set(rideInfoMap);
  }

  List<NearByAvailableDraivers> availableDrievrs;

  GlobalKey<ScaffoldState> scafuldKey = new GlobalKey<ScaffoldState>();
  List<LatLng> pLineCoerordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  Completer<GoogleMapController> _controllergoogleMap = Completer();
  GoogleMapController newGooglemapController;
  bool isTheAnyImge = false;
  double bottumpaddingofMap = 0;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.015137, 28.979530), // istanbul
    zoom: 14.4746,
  );
  bool drwoerOpen = true;
  Position currentPosition;
  DirectionDetails tripDiractionDetails;
  var geolocator = Geolocator();

  void locateposition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGooglemapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("this is your Address :: " + address);

    uName = "${usersCurrentInfo.name} ${usersCurrentInfo.surname}";

    initGeoFireListener();
  }

  resetApp() {
    setState(() {
      drwoerOpen = true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requistRideDetailsContainerHeight = 0;
      bottumpaddingofMap = 230.0;
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoerordinates.clear();

      // statusRide = "";
      // driverName = "";
      // driverPhone = "";
      // carDetailsDriver = "";
      // rideStatus = "Driver is coming";
      driverDetailsContainerHeight = 0.0;
    });
    // locatePosition();
  }

  void cancleRequist() {
    rideRequistRef.remove();
  }

  double searchContainerHeight = 300.0;
  double rideDetailsContainerHeight = 0;
  double requistRideDetailsContainerHeight = 0;
  double driverDetailsContainerHeight = 0;

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 380.0;
      bottumpaddingofMap = 360.0;
      drwoerOpen = false;
    });
    saveRideRequist();
  }

  void displayRequistHeightContainer() {
    setState(() {
      requistRideDetailsContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottumpaddingofMap = 230.0;
      drwoerOpen = true;
    });
  }

  void displayDriverDetailsContainer() {
    setState(() {
      requistRideDetailsContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottumpaddingofMap = 290.0;
      driverDetailsContainerHeight = 310.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    creatIconMarker();
    return Scaffold(
      key: scafuldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyColors.asfar_color),
        backgroundColor: MyColors.petroly_color,
        centerTitle: true,
        title: Text(
          "Map",
          style: TextStyle(color: MyColors.asfar_color),
        ),
      ),
      drawer: Container(
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //drower header
              Container(
                child: DrawerHeader(
                  decoration: BoxDecoration(color: MyColors.petroly_color),
                  child: Row(
                    children: [
                      Image.asset('images/user_icon.png',
                          height: 65.0, width: 65.0),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              uName,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Brand-bold",
                                  color: MyColors.asfar_color),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //drawer header end ...
              Divider(
                height: 1.0,
                color: Colors.white30,
                thickness: 1.0,
              ),
              SizedBox(height: 12.0),
              //draweer body
              GestureDetector(
                onTap: () {
                  // AsisstentMethods.retrieveHistoryInfo(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HestoryScreen()),
                  //);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.history,
                    color: MyColors.asfar_color,
                  ),
                  title: Text("History",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.screenId);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: MyColors.asfar_color,
                  ),
                  title: Text("profile Screen",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, AboutScreen.screenId);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.info,
                    color: MyColors.asfar_color,
                  ),
                  title: Text("About",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      )),
                ),
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.screenid, (route) => false);
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: MyColors.asfar_color,
                ),
                title: Text("Sign Out",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
              ),
              //draweer body End....
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottumpaddingofMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllergoogleMap.complete(controller);
              newGooglemapController = controller;
              setState(() {
                bottumpaddingofMap = 300.0;
              });

              locateposition();
            },
          ),
          // Hamburger btn . . .
          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                //display drawer ..

                if (drwoerOpen) {
                  scafuldKey.currentState.openDrawer();
                } else {
                  cancleRequist();
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drwoerOpen) ? Icons.menu : Icons.close,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          // Search Container  ui
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: Container(
              height: searchContainerHeight,
              decoration: BoxDecoration(
                  color: MyColors.petroly_color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.0),
                    SizedBox(height: 24.0),
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: MyColors.asfar_color,
                          size: 35,
                        ),
                        SizedBox(width: 12.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "your location :",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                Provider.of<AppData>(context).pickUpLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickUpLocation
                                        .placeName
                                    : "",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    DividerWidget(),
                    SizedBox(height: 40.0),
                    GestureDetector(
                      onTap: () async {
                        if (Provider.of<AppData>(context, listen: false)
                                .pickUpLocation
                                .placeName ==
                            null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ));
                        if (res == "obtainDirection") {
                          displayRideDetailsContainer();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.asfar_color,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              )
                            ]),
                        child: Container(
                          height: 60.0,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "where to go ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.petroly_color),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // car requist Container UI
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                    color: MyColors.petroly_color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      SizedBox(height: 35),
                      GestureDetector(
                        onTap: () {
                          // displayToastMsg("يتم البحث عن ديليفري جديد", context);
                          // setState(() {
                          //   state = "requisting";
                          //   carRideType = "bike";
                          // });
                          displayRequistHeightContainer();
                          availableDrievrs =
                              GeoFireAssistent.nearbyAvailableDraiversList;
                          // searchNearistDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          color: MyColors.asfar_color,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                Image.asset("images/cars/diliveryBike.png",
                                    height: 70.0, width: 90.0),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "delevery",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      ((tripDiractionDetails != null)
                                          ? tripDiractionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  ((tripDiractionDetails != null)
                                      ? '${(AssistantMethods.calculateFares(tripDiractionDetails))} TL'
                                      : ''),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Divider(height: 2.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          displayRequistHeightContainer();
                        },
                        child: Container(
                          width: double.infinity,
                          color: MyColors.asfar_color,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                //
                                Image.asset("images/cars/taxiQ.png",
                                    height: 70.0, width: 90.0),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Taxi",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      ((tripDiractionDetails != null)
                                          ? tripDiractionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  ((tripDiractionDetails != null)
                                      ? '${(AssistantMethods.calculateFares(tripDiractionDetails))} TL'
                                      : ''),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Divider(height: 2.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          //on tapp
                          // displayToastMsg("يتم البحث عن ديليفري جديد", context);
                          setState(() {
                            carRideType = "private car";
                            state = "requisting";
                          });
                          displayRequistHeightContainer();
                          availableDrievrs =
                              GeoFireAssistent.nearbyAvailableDraiversList;
                          searchNearistDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          color: MyColors.asfar_color,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                //
                                Image.asset("images/cars/car.png",
                                    height: 70.0, width: 90.0),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "private car",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      ((tripDiractionDetails != null)
                                          ? tripDiractionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  ((tripDiractionDetails != null)
                                      ? '${(AssistantMethods.calculateFares(tripDiractionDetails)) * 1.2} TL'
                                      : ''),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Divider(height: 2.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyCheckAlt,
                              size: 18.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              "cash",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 6.0),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // cancel requist..
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: requistRideDetailsContainerHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  color: MyColors.petroly_color,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 16.0,
                      color: Colors.black54,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText('Finding a Driver'),
                            WavyAnimatedText('please wait ...'),
                          ],
                          isRepeatingAnimation: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // cancleRequist();
                        resetApp();
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(
                              width: 2.0, color: MyColors.asfar_color),
                        ),
                        child: Icon(Icons.close,
                            size: 30, color: MyColors.asfar_color),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "cancle ride",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLanLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLanLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
      context: context,
      builder: (context) => ProgressDialog(message: "Please wait.."),
    );

    var details = await AssistantMethods.obtainDirectionDetails(
        pickUpLanLng, dropOffLanLng);
    setState(() {
      tripDiractionDetails = details;
    });

    Navigator.pop(context);

    print("this is encoded points :: ");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoerordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        // point add
        pLineCoerordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("PolylineID"),
        color: Colors.pink,
        jointType: JointType.round,
        points: pLineCoerordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
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

    newGooglemapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpMarker = Marker(
      markerId: MarkerId('PickupId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "my location"),
      position: pickUpLanLng,
    );
    Marker dropOffMarker = Marker(
      markerId: MarkerId('DropOffId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "Drop off location"),
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
      fillColor: Colors.purpleAccent,
      center: dropOffLanLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("DropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpCircle);
      circlesSet.add(dropOffCircle);
    });
  }

  void initGeoFireListener() {
    Geofire.initialize("availableDrivers");
    // comment
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 10)
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByAvailableDraivers nearbyavailableDraivers =
                NearByAvailableDraivers();
            nearbyavailableDraivers.key = map['key'];
            nearbyavailableDraivers.latitude = map['latitude'];
            nearbyavailableDraivers.longitude = map['longitude'];
            GeoFireAssistent.nearbyAvailableDraiversList
                .add(nearbyavailableDraivers);
            if (nearByAvailableDriverskeysLoaded == true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistent.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearByAvailableDraivers nearbyavailableDraivers =
                NearByAvailableDraivers();
            nearbyavailableDraivers.key = map['key'];
            nearbyavailableDraivers.latitude = map['latitude'];
            nearbyavailableDraivers.longitude = map['longitude'];
            GeoFireAssistent.updateDriverNearByLocation(
                nearbyavailableDraivers);
            updateAvailableDriversOnMap();
            // Update your key's location
            break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            updateAvailableDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
    // comment
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tmarkers = Set<Marker>();

    for (NearByAvailableDraivers draiver
        in GeoFireAssistent.nearbyAvailableDraiversList) {
      LatLng driverAvailablePosition =
          LatLng(draiver.latitude, draiver.longitude);

      Marker marker = Marker(
        markerId: MarkerId('driver${draiver.key}'),
        position: driverAvailablePosition,
        icon: nearByIcon,
        rotation: AssistantMethods.creatRandomNumber(360),
      );
      tmarkers.add(marker);
    }
    setState(() {
      markersSet = tmarkers;
    });
  }

  void creatIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/car_android.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void noDriversFond() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NoAvailableDriverDialog(),
    );
  }

  void searchNearistDriver() {
    if (availableDrievrs.length == 0) {
      cancleRequist();
      resetApp();
      noDriversFond();
      return;
    }
    var driver = availableDrievrs[0];
    // notifyDriver(driver);
    // availableDrievrs.removeAt(0);
    driversRef
        .child(driver.key)
        .child("car_details")
        .child("type")
        .once()
        .then((snap) async {
      if (await snap.value != null) {
        String car_type = snap.value.toString();
        if (car_type == carRideType) {
          notifyDriver(driver);
          availableDrievrs.removeAt(0);
        } else {
          displayToastMsg("there is no available driver now ! ", context);
        }
      } else {
        displayToastMsg(
            "there is no  availble driver nearby now please try again later ",
            context);
      }
    });
  }

  void notifyDriver(NearByAvailableDraivers driver) {
    driversRef.child(driver.key).child('newRide').set(rideRequistRef.key);
    driversRef
        .child(driver.key)
        .child('token')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String token = snapshot.value.toString();
        AssistantMethods.sendNotificationToDriver(
            token, context, rideRequistRef.key);
      } else {
        return;
      }
      const oneSecondPassed = Duration(seconds: 1);

      var timer = Timer.periodic(oneSecondPassed, (timer) {
        driverRequistTimeOnt = driverRequistTimeOnt - 1;

        if (state != "requisting") {
          driversRef.child(driver.key).child('newRide').set("cancelled");
          driversRef.child(driver.key).child('newRide').onDisconnect();
          driverRequistTimeOnt = 40;
          timer.cancel();

          searchNearistDriver();
        }
        driversRef.child(driver.key).child("newRide").onValue.listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.key).child('newRide').onDisconnect();
            driverRequistTimeOnt = 40;
            timer.cancel();
          }
        });

        if (driverRequistTimeOnt == 0) {
          driversRef.child(driver.key).child('newRide').set("timeout");
          driversRef.child(driver.key).child('newRide').onDisconnect();
          driverRequistTimeOnt = 40;
          timer.cancel();

          searchNearistDriver();
        }
      });
    });
  }

  void displayToastMsg(String msg, BuildContext cxt) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.green);
  }
}

void goToHisstor(BuildContext context) {
  Navigator.pushNamed(context, MyHistory.screenId);
}
