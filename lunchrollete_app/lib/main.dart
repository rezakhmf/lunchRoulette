import 'package:flutter/material.dart';

void main() => runApp(LunchRoulleteApp());

class LunchRoulleteApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return LunchRouletteState();
  }
}

class LunchRouletteState extends State<LunchRoulleteApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Lunch Roulette"),
          actions: <Widget>[],
        ),
      ),
    );
  }
}