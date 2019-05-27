import 'dart:io';
import 'package:flutter/material.dart';
import 'WBData.dart';
import 'WeightInput.dart';
import 'database.dart';
import 'wb_text.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'properties.dart' as props;

class WBSettingsPage extends StatefulWidget {
  @override
  _WBSettingsPageState createState() => _WBSettingsPageState();
}

class _WBSettingsPageState extends State<WBSettingsPage> {
  List<WBData> data = <WBData>[
    new WBData.weightKg(60, 0, WeightType.person, "Pilot:", true),
    new WBData.weightKg(60, 0, WeightType.person, "CoPilot:", true),
    new WBData.weightKg(0, 0, WeightType.person, "Pass1:", true),
    new WBData.weightKg(0, 0, WeightType.person, "Pass2:", true),
    new WBData.weightKg(15, 0, WeightType.bagage, "Bagg:", true),
    new WBData.fuelGal(27, 0, "Fuel", true)
  ];

  props.Property savePdf;

  Future<String> _getPdfPath() async {
    Directory tempDir = await path.getExternalStorageDirectory();
    print(tempDir);
    String tempPath = tempDir.path;
    return "$tempPath/Download/";
  }

//  Future<props.Property> _getProperty(String type, WBData data, bool boolValue) async
//  {
//    DBProvider db = DBProvider.db;
//    props.Property p = await db.getPropertyByField(type);
//    if (p == null) {
//      p = new props.Property(id: 0, field: type,
//          intValue: (data!=null)? data.value.round(): 0,
//          boolValue: boolValue, textValue: "");
//      await db.newProperty(p);
//    } else {
//      if (data != null) data.value = p.intValue.toDouble();
//    }
//    if (data != null) data.property = p;
//    return p;
//  }

  Future<String> _getDatafromDatabase() async {
    await getPropertyFromDB("pilot", data[0], false);
    await getPropertyFromDB("copilot", data[1], false);
    await getPropertyFromDB("pass1", data[2], false);
    await getPropertyFromDB("pass2", data[3], false);
    await getPropertyFromDB("bagg", data[4], false);
    await getPropertyFromDB("fuel", data[5], false);
    savePdf = await getPropertyFromDB("export", null, true);

    return _getPdfPath();
  }

  void _saveField(List<WBData> data)
  {
    DBProvider db = DBProvider.db;
    for(WBData d in data) {
      if (d.property != null) {
        d.property.intValue = d.value.round();
        db.updatePropertyByField(d.property);
      }
    }
  }

  Container _getContentContainer(String pdfPath)
  {
    return (
        Container(
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
                    onInputDataChanged: _saveField,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0,20,0, 10),
                child: getBoldText("Save Weight & Balance report:", 15),
              ),
              getText("Path: " + pdfPath, 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getText("Save PDF: ", 15),
                  Checkbox(
                    value: savePdf.boolValue,
                    onChanged: (bool value) {
                      setState(() {
                        savePdf.boolValue = value;
                        DBProvider db = DBProvider.db;
                        db.updatePropertyByField(savePdf);
                      });
                    },
                  )
                ],
              )
            ],
          ),
        )
    );
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
        body: FutureBuilder<String>(
            future: _getDatafromDatabase(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData)
                return _getContentContainer(snapshot.data);
              else return Center(child: getBoldText("Retrieving Data...", 15),);
            }),
      )
    );
  }
}