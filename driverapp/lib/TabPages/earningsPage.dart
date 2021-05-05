import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../allScreen/HestoryScreen.dart';
import '../allwidgets/CustomColors.dart';
import '../dataHandler/appData.dart';

class EarningsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: CostumColors.petroly_color, boxShadow: [
            BoxShadow(
                spreadRadius: 100,
                offset: Offset(0.7, 0.7),
                blurRadius: 10,
                color: Colors.black54),
          ]),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Column(
              children: [
                Text(
                  'مجموع الارباح',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "${Provider.of<AppData>(context, listen: false).earnings}",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 70.0),
                ),
              ],
            ),
          ),
        ),
        FlatButton(
            color: Colors.white,
            textColor: Colors.green,
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HestoryScreen(),
                  ));
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      Provider.of<AppData>(context, listen: false)
                          .countTrip
                          .toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: Text(
                      "سجل الرحلات",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                  Image.asset("images/cars/skoda3.png", width: 110.0),
                ],
              ),
            )),
        Divider(height: 2.0, thickness: 2.0),
      ],
    );
  }
}
