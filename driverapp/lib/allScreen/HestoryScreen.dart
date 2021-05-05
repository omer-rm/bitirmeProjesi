import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../allwidgets/CustomColors.dart';
import '../allwidgets/HestoryItems.dart';
import '../dataHandler/appData.dart';

class HestoryScreen extends StatefulWidget {
  @override
  _HestoryScreenState createState() => _HestoryScreenState();
}

class _HestoryScreenState extends State<HestoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الرجوع",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: CostumColors.petroly_color,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          return HestoryItem(
            history: Provider.of<AppData>(context, listen: false)
                .tripHestoryDetailsList[index],
          );
        },
        separatorBuilder: (context, index) =>
            Divider(thickness: 3.0, height: 3.0),
        itemCount: Provider.of<AppData>(context, listen: false)
            .tripHestoryDetailsList
            .length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
