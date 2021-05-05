import './Models/allUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';

String mapKey = "AIzaSyBN7zqyDG825qleWDyWJoSTOrgMU1mjk-g";

User firebaseUsers;
Users usersCurrentInfo;

int driverRequistTimeOnt = 40;

String statusRide = "";
String rideStatus = "on the way";
String carDetailsDriver = "";
String driverName = "";
String driverPhone = "";

double starCounter = 0.0;
String title = "";
String carRideType = "";
