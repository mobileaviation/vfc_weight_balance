import 'package:flutter/material.dart';
import 'wbhome-content.dart';
import 'Airplanes.dart';

class WBHomePage extends StatelessWidget {
  WBHomePage({Key key, this.title, this.airplane}) : super(key: key);

  String title;
  Airplane airplane;

  @override
  Widget build(BuildContext context) {
    return
      new Scaffold(
        appBar: new AppBar(
          title: new Text(
            title,
            style: new TextStyle(
                color: Colors.white, fontFamily: 'Nunito', letterSpacing: 1.0, fontSize: 15),
          ),
          backgroundColor: new Color(0xFF2979FF),
          centerTitle: true,
        ),
        body: new WBHomepageContent(title: title, airplane: airplane,));
  }

}