import 'package:flutter/material.dart';
import '../Assistants/assistentMethods.dart';
import '../allwidgets/CustomColors.dart';
import '../configMaps.dart';

class CollectFareDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;

  CollectFareDialog({this.fareAmount, this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CostumColors.petroly_color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0),
            Text(
              "(" + rideType + ") :The profits of the trip",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 22.0),
            Divider(),
            SizedBox(height: 16.0),
            Text(
              "\$$fareAmount",
              style: TextStyle(fontSize: 55.0, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "These are all the profits that were collected from the trips, given to the driver",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: RaisedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  //  AsisstentMethods.enableHomeTabLiveLocationUpdate();
                },
                color: CostumColors.asfar_color,
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "The amount",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: CostumColors.petroly_color,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.attach_money,
                        color: CostumColors.petroly_color,
                        size: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
