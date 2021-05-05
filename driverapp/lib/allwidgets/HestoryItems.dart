import 'package:flutter/material.dart';
import '../Assistants/assistentMethods.dart';
import '../Models/hestoy.dart';

class HestoryItem extends StatelessWidget {
  final Hestory history;
  HestoryItem({this.history});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Image.asset("images/pickicon.png", height: 16.0, width: 16.0),
                SizedBox(width: 18.0),
                Expanded(
                  child: Container(
                    child: Text(
                      history.pickUp,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("images/desticon.png", height: 16.0, width: 16.0),
              SizedBox(width: 18.0),
              Expanded(
                child: Container(
                  child: Text(
                    history.dropOff,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              SizedBox(width: 5.0),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            AsisstentMethods.fromTripDate(history.createdAt),
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
