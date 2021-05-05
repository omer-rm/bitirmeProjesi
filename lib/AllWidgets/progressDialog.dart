import '../myColors/MyColors.dart';
import "package:flutter/material.dart";

// ignore: must_be_immutable
class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        backgroundColor: MyColors.petroly_color,
        child: Container(
          margin: EdgeInsets.all(15.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColors.petroly_color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                SizedBox(width: 6.0),
                CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(MyColors.asfar_color)),
                SizedBox(width: 22.0),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
