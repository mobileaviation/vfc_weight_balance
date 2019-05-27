import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'wbchart-holder.dart';
import 'Airplanes.dart';
import 'WeightInput.dart';
import 'InputPart.dart';
import 'calculate_wb.dart';
import 'WBData.dart';
import 'wb_table.dart';
import 'export_pdf.dart';
import 'dart:ui' as ui;
import 'properties.dart' as props;
import 'database.dart';
import 'wb_text.dart';

class WBHomepageContent extends StatefulWidget {
  WBHomepageContent({Key key, this.title, this.airplane}) : super(key: key);
  String title;
  Airplane airplane;

  @override
  _HomeContentState createState() => _HomeContentState(title, airplane);
}

class _HomeContentState extends State<WBHomepageContent> {
  _HomeContentState(String title, Airplane airplane) {
    _title = title;
    _airplane = airplane;
    _init();
  }

  String _title;
  Airplane _airplane;
  List<WBData> inputData;
  WBData _takeoffWB;
  WBData _zfwWB;
  WBData _rampWB;
  bool _savePdf;
  bool _defaultDataLoaded = false;

  Future<bool> _getDefaultData() async {
    if (!_defaultDataLoaded) {
      await getPropertyFromDB('pilot', inputData[0], false);
      await getPropertyFromDB('copilot', inputData[1], false);
      await getPropertyFromDB('pass1', inputData[2], false);
      await getPropertyFromDB('pass2', inputData[3], false);
      await getPropertyFromDB('bagg', inputData[4], false);
      await getPropertyFromDB('fuel', inputData[5], false);
      props.Property p = await getPropertyFromDB('export', null, true);
      _savePdf = p.boolValue;
      _defaultDataLoaded = true;
    }

    _calc(inputData);
    return _savePdf;
  }

  void _init() {
    inputData = <WBData>[
      WBData.weightKg(
          60, _airplane.frontArm, WeightType.person, "Pilot:", true),
      WBData.weightKg(
          60, _airplane.frontArm, WeightType.person, "CoPilot:", true),
      WBData.weightKg(0, _airplane.rearArm, WeightType.person, "Pass1:", true),
      WBData.weightKg(0, _airplane.rearArm, WeightType.person, "Pass2:", true),
      WBData.weightKg(
          15, _airplane.bagageArm, WeightType.bagage, "Bagg:", true),
      WBData.fuelGal(26, _airplane.feulArm, "Fuel:", true),
      WBData.fuelGal(2, _airplane.feulArm, "Taxi fuel:", false),
    ];
  }

  Future _calc(List<WBData> data) async {
    CalculateWB calc = new CalculateWB(data, _airplane);
    setState(() {
      _takeoffWB = calc.calculateTakeoffWB(6);
      _zfwWB = calc.calculateZeroFuelWB();
      _rampWB = calc.calculateRampWB();
      if (_takeoffWB != null) _storePdf();
    });
  }

  WBChartHolder _getChartHolder() {
    return new WBChartHolder(_airplane, _takeoffWB, _zfwWB);
  }

  Future _storePdf() async {
    if (_savePdf) {
      PdfExport pdfExport = PdfExport();
      Size s = new Size(350, 350);
      WBChartHolder chart = new WBChartHolder(_airplane, _takeoffWB, _zfwWB);
      ui.Image image =
          await chart.getImageData(_airplane, _takeoffWB, _zfwWB, s);
      pdfExport.Generate(
          inputData, _airplane, _zfwWB, _takeoffWB, _rampWB, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    Container container = new Container(
      child: FutureBuilder(
        future: _getDefaultData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Expanded(
                      child: new AspectRatio(
                        aspectRatio: 1,
                        child: new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new PageView(
                              children: <Widget>[
                                new Container(
                                    color: Color(0xffCCFF66),
                                    child: new CustomPaint(
                                      foregroundPainter: _getChartHolder(),
                                    )),
                                new WBTable(
                                  inputData: inputData,
                                  airplane: _airplane,
                                  zfwWB: _zfwWB,
                                  rampWB: _rampWB,
                                  takeoffWB: _takeoffWB,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WeightInput(
                      inputData: inputData,
                      onInputDataChanged: _calc,
                    ),
//              FutureBuilder<bool>(
//                future: _getDefaultData(),
//                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//                  if (snapshot.hasData) {
//                    return WeightInput(
//                      inputData: inputData,
//                      onInputDataChanged: _calc,
//                    );
//                  } else return Center(child: getBoldText("Retrieving Data...", 15),);
//                },
//              )
                  ],
                ),
              ],
            );
          } else
            return Center(
              child: getBoldText("Retrieving Data...", 15),
            );
        }, //---
      ),
    );
    return container;
  }
}
