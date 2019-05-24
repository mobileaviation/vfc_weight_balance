import 'package:flutter/material.dart';



Widget getTextSize11(String _title) {
  return (
      getText(_title, 11.0)
  );
}

Widget _getText(String _title, double size, FontWeight weight) {
  return (
      Text(
        _title,
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: size,
          decoration: TextDecoration.none,
          fontFamily: 'Arial',
          fontWeight: weight,
          color: Color(0xFF585858)
        ),
      )
  );
}

Widget getBoldText(String _title, double size) {
  return _getText(_title, size, FontWeight.bold);
}

Widget getText(String _title, double size) {
  return _getText(_title, size, FontWeight.normal);
}


Widget getTextDialog(String _title) {
  return (
      Center(
        child: Text(
          _title,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 15.0,
            decoration: TextDecoration.none,
            fontFamily: 'Arial',
            fontWeight: FontWeight.normal,
          ),
        )
      )

  );
}
