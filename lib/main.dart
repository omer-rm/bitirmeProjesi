import './DataHandler/appData.dart';
import './Screens/homescreen.dart';
import './Screens/about.dart';
import './Screens/loginScreen.dart';
import './Screens/myHistory.dart';
import './Screens/profileScreen.dart';
import './myColors/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bitirme Projesi',
        theme: ThemeData(
          fontFamily: "Righteous",
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: MyColors.petroly_color,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.screenid
            : HomeScreen.screenId,
        // initialRoute: LoginScreen.screenid,
        routes: {
          HomeScreen.screenId: (context) => HomeScreen(),
          MyHistory.screenId: (context) => MyHistory(),
          ProfileScreen.screenId: (context) => ProfileScreen(),
          AboutScereen.screenid: (context) => AboutScereen(),
          LoginScreen.screenid: (context) => LoginScreen(),
        },
      ),
    );
  }
}
