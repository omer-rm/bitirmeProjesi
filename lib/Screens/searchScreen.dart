import '../AllWidgets/divider.dart';
import '../AllWidgets/progressDialog.dart';
import '../Assistants/requestAssistant.dart';
import '../DataHandler/appData.dart';
import '../Models/PlacePredictions.dart';
import '../Models/address.dart';
import '../myColors/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configmaps.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUptextEditingController = TextEditingController();
  TextEditingController dropofftextEditingController = TextEditingController();

  List<PlacePredictions> placePredectionList = [];
  @override
  Widget build(BuildContext context) {
    String placeAdress =
        Provider.of<AppData>(context).pickUpLocation.placeName == null
            ? ""
            : Provider.of<AppData>(context).pickUpLocation.placeName;

    pickUptextEditingController.text = placeAdress;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // childn the clomun
            Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: MyColors.petroly_color,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7)),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 25.0, top: 50.0, right: 25.0, bottom: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white70,
                            )),
                        Image.asset(
                          "images/logo/quicklyLogo.png",
                          width: 130,
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Stack(
                      children: [
                        Center(
                          child: Text(
                            "where is your destination ",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand-bold",
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Image.asset("images/pickicon.png",
                            height: 16.0, width: 16.0),
                        SizedBox(width: 18.0),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUptextEditingController,
                              decoration: InputDecoration(
                                hintText: 'pickUp Location ',
                                fillColor: MyColors.petroly_color,
                                filled: true,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Image.asset("images/desticon.png",
                            height: 16.0, width: 16.0),
                        SizedBox(width: 18.0),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (value) {
                                finedPlace(value);
                              },
                              controller: dropofftextEditingController,
                              decoration: InputDecoration(
                                hintText: 'where to ?',
                                hintStyle: TextStyle(color: Colors.white70),
                                fillColor: MyColors.petroly_color,
                                filled: true,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // list
            (placePredectionList.length > 0)
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PredectionsTails(
                          placePredictions: placePredectionList[index],
                        );
                      },
                      separatorBuilder: (context, index) => DividerWidget(),
                      itemCount: placePredectionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

// mer
  void finedPlace(String placename) async {
    if (placename.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placename&key=$mapKey&sessiontoken=1234567890&components=country:tr";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredectionList = placeList;
        });
      }
    }
  }
}

class PredectionsTails extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredectionsTails({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getplaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    children: [
                      Text(placePredictions.main_text ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 3.0),
                      Text(placePredictions.secondary_text ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void getplaceAddressDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        message: "setting drop off please wait .... ",
      ),
    );
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (res == "failed") {
      return;
    }

    if (res["status"] == "OK") {
      Address address = Address();

      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);

      print("this is drop of location :: ");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}
