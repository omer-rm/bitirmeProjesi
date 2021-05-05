import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allScreen/mainScreen.dart';
import '../allwidgets/CustomColors.dart';
import '../configMaps.dart';
import '../main.dart';

class CarInfoScreen extends StatelessWidget {
  static const String idScreen = "carinfo";

  TextEditingController carModelTextEditiongContriller =
      TextEditingController();
  TextEditingController carNumberTextEditiongContriller =
      TextEditingController();
  TextEditingController carColorTextEditiongContriller =
      TextEditingController();

  List<String> carTypeLIST = ["taxi", "private car", "bike"];

  String selectedCarType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CostumColors.petroly_color,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              SizedBox(height: 24.0),
              Image(
                image: AssetImage('images/logos/quicklyIcon.png'),
                height: 150.0,
                width: 150.0,
                alignment: Alignment.center,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0),
                    Text(
                      "Enter your car information",
                      style: TextStyle(
                          fontFamily: "Brand-blod",
                          fontSize: 24.0,
                          color: Colors.white),
                    ),
                    SizedBox(height: 26.0),
                    //car model input ..
                    TextField(
                      textAlign: TextAlign.center,
                      controller: carModelTextEditiongContriller,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Car model',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    //car number input ..
                    TextField(
                      textAlign: TextAlign.center,
                      controller: carNumberTextEditiongContriller,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Plate number',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    //car color input ..
                    TextField(
                      textAlign: TextAlign.center,
                      controller: carColorTextEditiongContriller,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Car color',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 26.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                            iconSize: 35,
                            hint: Text(
                              "Choose: Motorcycle - Taxi - Personal Car",
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 16.0),
                            ),
                            value: selectedCarType,
                            items: carTypeLIST.map((cartype) {
                              return DropdownMenuItem(
                                child: new Text(cartype),
                                value: cartype,
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              selectedCarType = newValue;
                              displayToastMsg(selectedCarType, context);
                            }),
                      ],
                    ),
                    SizedBox(height: 42.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (carColorTextEditiongContriller.text.isEmpty ||
                              carModelTextEditiongContriller.text.isEmpty ||
                              carNumberTextEditiongContriller.text.isEmpty) {
                            displayToastMsg(
                                'You left a blank, please try again', context);
                          } else {
                            if (selectedCarType == null) {
                              displayToastMsg(
                                  "Please select the vehicle type", context);
                              return;
                            } else {
                              saveDriverInfo(context);
                            }
                          }
                        },
                        color: CostumColors.asfar_color,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: CostumColors.petroly_color),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDriverInfo(BuildContext context) {
    String userId = currentfirebaseuser.uid;
    Map carInfoMap = {
      "car_color": carColorTextEditiongContriller.text,
      "car_number": carNumberTextEditiongContriller.text,
      "car_model": carModelTextEditiongContriller.text,
      "type": selectedCarType,
    };
    dirversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }

  void displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.red);
  }
}
