import 'package:sonbitirmeprojesi/Models/nearByAvailbleDrivers.dart';

class GeoFireAssistent {
  static List<NearByAvailableDraivers> nearbyAvailableDraiversList =
      []; // [d1 , d2 , d3 ]

  static void removeDriverFromList(String key) {
    int index =
        nearbyAvailableDraiversList.indexWhere((element) => element.key == key);
    nearbyAvailableDraiversList.remove(index);
  }

  static void updateDriverNearByLocation(NearByAvailableDraivers driver) {
    int index = nearbyAvailableDraiversList
        .indexWhere((element) => element.key == driver.key);

    nearbyAvailableDraiversList[index].latitude = driver.latitude;
    nearbyAvailableDraiversList[index].longitude = driver.longitude;
  }
}
