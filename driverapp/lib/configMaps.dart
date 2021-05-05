import 'dart:async';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import './Models/allUsers.dart';
import './Models/drivers.dart';

String mapKey = "AIzaSyDPOeLUgf4-1tpD4KSVG6a51YFSTfCy1R4";

User firebaseUsers;

Users usersCurrentInfo;

User currentfirebaseuser;

StreamSubscription<Position> hometapPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

// final assetsAudioplayer = AssetsAudioPlayer();

Position currentPos;

Drivers driversInformation;

String title = "لا يوجد تقيمات ";

double starCounter = 0.0;

String rideType = "";

// taxi , private car , bike
