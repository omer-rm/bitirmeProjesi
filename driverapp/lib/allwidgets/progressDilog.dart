import 'package:flutter/material.dart';
import '../allwidgets/CustomColors.dart';

class ProgressDialog extends StatelessWidget {
  final String massage;
  ProgressDialog({this.massage});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        backgroundColor: CostumColors.petroly_color,
        child: Container(
          margin: EdgeInsets.all(15.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: CostumColors.petroly_color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                SizedBox(width: 6.0),
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        CostumColors.asfar_color)),
                SizedBox(width: 22.0),
                Expanded(
                  child: Text(
                    massage,
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
