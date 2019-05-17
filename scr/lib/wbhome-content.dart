import 'package:flutter/material.dart';
import 'wbchart-holder.dart';
import 'Airplanes.dart';
import 'WeightInput.dart';
import 'InputPart.dart';
import 'calculate_wb.dart';
import 'WBData.dart';
import 'wb_table.dart';

class WBHomepageContent extends StatefulWidget {
  WBHomepageContent({Key key, this.title}) : super(key: key);
  String title;

  @override
  _HomeContentState createState() => _HomeContentState(title);
}

class _HomeContentState extends State<WBHomepageContent> {
  _HomeContentState(String title) {
    _title = title;
    _init();
  }

  String _title;
  Airplane a;
  List<WBData> inputData;
  WBData _takeoffWB;
  WBData _zfwWB;
  WBData _rampWB;

  void _init(){
    a = new Airplanes().getAirplaneByCallsign("PHDRT");
    inputData = <WBData> [
      WBData.weightKg(60, a.frontArm, WeightType.person, "Pilot:", true),
      WBData.weightKg(60, a.frontArm, WeightType.person, "CoPilot:", true),
      WBData.weightKg(0, a.rearArm, WeightType.person, "Pass1:", true),
      WBData.weightKg(0, a.rearArm, WeightType.person, "Pass2:", true),
      WBData.weightKg(15, a.bagageArm, WeightType.bagage, "Bagg:", true),
      WBData.fuelGal(26, a.feulArm, "Fuel:", true),
      WBData.fuelGal(2, a.feulArm, "Taxi fuel:", false),
    ];
  }

  void _calc(List<WBData> data)
  {
    CalculateWB calc = new CalculateWB(data, a);
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
                              foregroundPainter: new WBChartHolder(a, _takeoffWB),)
                        ),
                        new WBTable(
                          inputData: inputData,
                          airplane: a,
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
