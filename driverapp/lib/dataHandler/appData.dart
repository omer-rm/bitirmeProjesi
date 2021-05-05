import 'package:flutter/cupertino.dart';
import '../Models/hestoy.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int countTrip = 0;

  List<String> trpHestorykeys = [];
  List<Hestory> tripHestoryDetailsList = [];

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounters(int tripCounter) {
    countTrip = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    trpHestorykeys = newKeys;
    notifyListeners();
  }

  void updatedHistoryTripData(Hestory eachhistory) {
    tripHestoryDetailsList.add(eachhistory);
    notifyListeners();
  }

  void clearHestory() {
    tripHestoryDetailsList.clear();
    notifyListeners();
  }
}
