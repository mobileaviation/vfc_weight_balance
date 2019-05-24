import 'package:flutter/material.dart';
import 'wb_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Airplanes.dart';

class WBStart extends StatefulWidget {
  WBStart({Key key, this.airplaneSelected}): super(key: key);

  ValueChanged<Airplane> airplaneSelected;
  @override
  _WBStartState createState() => _WBStartState();
}

class _WBStartState extends State<WBStart> {
  List<String> items = new List();
  Map<String, Airplane> _airplanes = new Map();
  String _selected_airplane;

  Widget _getDropdownButton(AsyncSnapshot snapshot)
  {
    return (
        new DropdownButton<String>(
            items: _getItems(snapshot),
            value: _selected_airplane,
            onChanged: (String newValue) {
              setState(() {
                _selected_airplane = newValue;
                Airplane a = _airplanes[_selected_airplane];
                widget.airplaneSelected(a);
              });
            })
    );
  }

  List<DropdownMenuItem<String>> _getItems(AsyncSnapshot snapshot)
  {
    List<DropdownMenuItem<String>> l = new List<DropdownMenuItem<String>>();
    for (int i=0; i<snapshot.data.documents.length; i++ ) {
      DocumentSnapshot doc = snapshot.data.documents[i];
      String v = doc.data["call_sign"];
      Airplane item = Airplane.fromJson(doc.data);
      _airplanes[v] = item;

      items.add(v);
      DropdownMenuItem<String> dditem = new DropdownMenuItem(
          child: getText(v, 12),
          value: v,
      );
      l.add(dditem);
    }
    
    return l;
  }
  
  StreamBuilder _getFirebaseData() {
    return StreamBuilder(
      stream: Firestore.instance.collection('VCFAirplanes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return getText("Loading..", 12);
        return _getDropdownButton(snapshot);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/vliegclub-flevo.png"),
            getText("Vliegclub Flevo", 15),
            getText("Weight & Balance Calculator", 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getText("Select Airplane: ", 12),
                _getFirebaseData(),
              ],
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}

class AirplaneItem {
  String callsign;
}
