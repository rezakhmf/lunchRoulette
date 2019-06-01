import 'package:flutter/material.dart';

void main() => runApp(LunchRoulleteApp());

class LunchRoulleteApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return LunchRoulleteState();
  }
}

class LunchRoulleteState extends State<LunchRoulleteApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("hello collegue"),
          actions: <Widget>[],
        ),
      ),
    );
  }
}