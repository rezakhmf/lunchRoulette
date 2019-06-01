import 'package:flutter/material.dart';
import '../model/Staff.dart';

class StaffCell extends StatelessWidget {
  Staff _staff;

  StaffCell(this._staff);

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Image.network(this._staff.imageUrl),
              new Container(
                height: 8.0,
              ),
              new Text(
                "${this._staff.name} ${this._staff.family}",
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              new Text(
                "foodie level: ${this._staff.foodie}",
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
