import 'package:flutter/material.dart';
import 'wbhome.dart';

void main() => runApp(WBApp());

class WBApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplane Weight and Balance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: new WBHomePage(title: 'Weight and Balance Calculator'),
    );
  }
}