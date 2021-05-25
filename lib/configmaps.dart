import './Models/allUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';

String mapKey = "AIzaSyBN7zqyDG825qleWDyWJoSTOrgMU1mjk-g";
String serverToken =
    "key=AAAAnLnxE3o:APA91bH52WGm2ibHHVcjfbQOL03IQAV6vOYcglhk3WIVVJhSUr4K2uuoOpjer92mZ7OW-VjMTGmzP8CDkC6ZVrUklrM_pkcreRvDhCU0cwZg3bHl8KUCGf7iUsyvB9pigGFKGKobpipO";
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
