import 'package:flutter/material.dart';
import 'wbchart-holder.dart';
import 'Airplanes.dart';
import 'WeightInput.dart';
import 'InputPart.dart';
import 'calculate_wb.dart';
import 'WBData.dart';
import 'wb_table.dart';

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

  void _init(){
    //a = widget.airplane;//new Airplanes().getAirplaneByCallsign("PHDRT");
    inputData = <WBData> [
      WBData.weightKg(60, _airplane.frontArm, WeightType.person, "Pilot:", true),
      WBData.weightKg(60, _airplane.frontArm, WeightType.person, "CoPilot:", true),
      WBData.weightKg(0, _airplane.rearArm, WeightType.person, "Pass1:", true),
      WBData.weightKg(0, _airplane.rearArm, WeightType.person, "Pass2:", true),
      WBData.weightKg(15, _airplane.bagageArm, WeightType.bagage, "Bagg:", true),
      WBData.fuelGal(26, _airplane.feulArm, "Fuel:", true),
      WBData.fuelGal(2, _airplane.feulArm, "Taxi fuel:", false),
    ];
  }

  void _calc(List<WBData> data)
  {
    CalculateWB calc = new CalculateWB(data, _airplane);
    setState(() {
      _takeoffWB = calc.calculateTakeoffWB(6);
      _zfwWB = calc.calculateZeroFuelWB();
      _rampWB = calc.calculateRampWB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Expanded(
                child: new AspectRatio(
                  aspectRatio: 1,
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    new PageView(
                      children: <Widget>[
                        new Container(
                            color: Color(0xffCCFF66),
                            child: new CustomPaint(
                              foregroundPainter: new WBChartHolder(_airplane, _takeoffWB, _zfwWB),)
                        ),
                        new WBTable(
                          inputData: inputData,
                          airplane: _airplane,
                          zfwWB: _zfwWB,
                          rampWB: _rampWB,
                          takeoffWB: _takeoffWB,
                        ),
                      ],
                    )
                  ),
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
            ],
          ),
        ],
      ),
    );
  }
}
