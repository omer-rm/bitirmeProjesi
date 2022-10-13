// import 'package:driverapp/allwidgets/CustomColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './allScreen/LginScreen.dart';
import './allScreen/carInfoScreen.dart';
import './allScreen/mainScreen.dart';
import './allScreen/signupScreen.dart';
import './configMaps.dart';
import './dataHandler/appData.dart';
import 'allwidgets/CustomColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseuser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference dirversRef =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequistRef =
    FirebaseDatabase.instance.reference().child("RideRequests");
DatabaseReference rideRequistRef = FirebaseDatabase.instance
    .reference()
    .child("drivers")
    .child(currentfirebaseuser.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quickly Driver',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: CostumColors.petroly_color,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          SignUpScreen.idScreen: (context) => SignUpScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
        },
      ),
    );
  }
}
