import 'package:flutter/material.dart';
import 'wbhome.dart';
import 'start.dart';

void main() => runApp(MaterialApp(
  title: "Weight and Balance",
  home: WBApp(),
));

class WBApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplane Weight and Balance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: new WBStart(
        airplaneSelected: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  WBHomePage(title: 'Weight and Balance Calculator',
                    airplane: value, )));
        },
      ),//new WBHomePage(title: 'Weight and Balance Calculator'),
    );
  }
}