import 'package:flutter/material.dart';
import 'package:sonbitirmeprojesi/Assistants/assistantMethods.dart';
import 'package:sonbitirmeprojesi/myColors/MyColors.dart';

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
          color: MyColors.petroly_color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0),
            Divider(height: 2.0, thickness: 2.0),
            SizedBox(height: 16.0),
            Text(
              "\$$fareAmount",
              style: TextStyle(fontSize: 55.0, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "This is the total trip amount , it has been charged to the rider .",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(12.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: () async {
                  Navigator.pop(context, "close");

                  // AssistantMethods.enableHomeTabLiveLocationUpdate();
                },
                color: MyColors.asfar_color,
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "pay cash",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: MyColors.petroly_color,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.attach_money,
                        color: MyColors.petroly_color,
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
