import 'dart:io';
import 'package:flutter/material.dart';
import 'WBData.dart';
import 'InputPart.dart';
import 'WeightInput.dart';
import 'wb_text.dart';
import 'package:path_provider/path_provider.dart' as path;

class WBSettingsPage extends StatefulWidget {
  @override
  _WBSettingsPageState createState() => _WBSettingsPageState();
}

class _WBSettingsPageState extends State<WBSettingsPage> {

  @override
  void initState() {
    super.initState();
    _getPdfPath().then((onValue) {
      if (mounted) setState(() {
        downloadPath = onValue;
      });
    });
  }

  List<WBData> data = <WBData>[
    new WBData.weightKg(60, 0, WeightType.person, "Pilot:", true),
    new WBData.weightKg(60, 0, WeightType.person, "CoPilot:", true),
    new WBData.weightKg(0, 0, WeightType.person, "Pass1:", true),
    new WBData.weightKg(0, 0, WeightType.person, "Pass2:", true),
    new WBData.weightKg(15, 0, WeightType.bagage, "Bagg:", true),
    new WBData.fuelGal(27, 0, "Fuel", true)
  ];

  String downloadPath = "Unknown";
  bool savePdf = true;
  
  Future<String> _getPdfPath() async {
    Directory tempDir = await path.getExternalStorageDirectory();
    print(tempDir);
    String tempPath = tempDir.path;
    return "$tempPath/Download/";
  }

  @override
  Widget build(BuildContext context) {
    return (
      new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Settings",
            style: new TextStyle(
                color: Colors.white, fontFamily: 'Nunito', letterSpacing: 1.0, fontSize: 15),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0,20,0, 10),
                child: getBoldText("Default values:", 15),
              ),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  WeightInput(
                    inputData: data,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0,20,0, 10),
                child: getBoldText("Save Weight & Balance report:", 15),
              ),
              getText("Path: " + downloadPath, 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getText("Save PDF: ", 15),
                  Checkbox(
                    value: savePdf,
                    onChanged: (bool value) {
                      setState(() {
                        savePdf = value;
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}