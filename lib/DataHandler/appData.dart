import '../Models/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;
  void updatePickUpLocationAddress(Address pickupAddrss) {
    pickUpLocation = pickupAddrss;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropoffAddress) {
    dropOffLocation = dropoffAddress;
    notifyListeners();
  }
}
