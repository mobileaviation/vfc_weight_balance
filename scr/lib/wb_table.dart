import 'package:flutter/material.dart';
import 'WBData.dart';
import 'Airplanes.dart';
import 'wb_text.dart';
import 'dart:math';

class WBTable extends StatelessWidget {
  WBTable({Key key, List<WBData> this.inputData, Airplane this.airplane,
    WBData this.zfwWB, WBData, this.rampWB, WBData this.takeoffWB})
      : super(key: key);

  List<WBData> inputData;
  Airplane airplane;
  WBData zfwWB;
  WBData takeoffWB;
  WBData rampWB;

  TableBorder _getBorder(double size, bool top, bool bottom) {
    return TableBorder(
      top: (top) ? BorderSide(width: size, color: Colors.black) : BorderSide.none,
      verticalInside: BorderSide(width: size, color: Colors.black),
      left: BorderSide(width: size, color: Colors.black),
      right: BorderSide(width: size, color: Colors.black),
      bottom: (bottom) ? BorderSide(width: size, color: Colors.black) : BorderSide.none,
    );
  }

  Table _buildHeaderRow(String val1, String val2, String val3, String val4, TableBorder border, bool decoration) {
    Map<int, TableColumnWidth> widths = new Map<int, TableColumnWidth>();
    widths[0] = FixedColumnWidth(100);
    return (Table(
      border: border,
      columnWidths :widths,
      children: [
        new TableRow(
          decoration: (decoration) ? BoxDecoration(color: Color(0x33000000)) : null,
          children: [
            TableCell(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: getText(val1, 12)),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: getText(val2, 12)),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: getText(val3, 12)),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: getText(val4, 12)),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  List<Widget> _getChidren()
  {
    double front_lbs = inputData[0].weightLbs + inputData[1].weightLbs;
    double back_lbs = inputData[2].weightLbs + inputData[3].weightLbs;
    double bag_lbs = inputData[4].weightLbs;

    double front_lbsin = inputData[0].moment + inputData[1].moment;
    double back_lbsin = inputData[2].moment + inputData[3].moment;
    double bag_lbsin = inputData[4].moment;

    double zfw = airplane.bew + front_lbs + back_lbs + bag_lbs;
    double zfw_moment = airplane.beMoment + front_lbsin + back_lbsin + bag_lbsin;

    List<Widget> rows = <Widget> [
        _buildHeaderRow("Station", "lbs", "in", "in-lbs", _getBorder(2.0, true, true), true),
        _buildHeaderRow("BEW", _toStringClean(airplane.bew, 1.0),
            _toStringClean(airplane.beArm, 2.0),
            _toStringClean(airplane.beMoment, 2.0),  _getBorder(1.0, false, true), false),
        _buildHeaderRow("Front", _toStringClean(front_lbs, 1.0),
            _toStringClean(airplane.frontArm, 2.0),
            _toStringClean(front_lbsin, 2.0),  _getBorder(1.0, false, true),false),
        _buildHeaderRow("Rear", _toStringClean(back_lbs, 1.0),
            _toStringClean(airplane.rearArm, 2.0),
            _toStringClean(back_lbsin, 2.0),  _getBorder(1.0, false, true), false),
        _buildHeaderRow("bagage", _toStringClean(bag_lbs, 1.0),
          _toStringClean(airplane.bagageArm, 2.0),
          _toStringClean(bag_lbsin, 2.0),  _getBorder(1.0, false, false), false),
      ];

    if (zfwWB!=null && takeoffWB!=null) {
      rows.add(_buildHeaderRow("ZFW", _toStringClean(zfwWB.weightLbs, 1.0),
          _toStringClean(zfwWB.arm, 2.0),
          _toStringClean(zfwWB.moment, 2.0), _getBorder(2.0, true, true), true));
      rows.add(_buildHeaderRow("Total fuel", _toStringClean(inputData[5].weightLbs, 1.0),
          _toStringClean(inputData[5].arm, 2.0),
          _toStringClean(inputData[5].moment, 2.0), _getBorder(2.0, false, true), false));
      rows.add(_buildHeaderRow("Ramp weight", _toStringClean(rampWB.weightLbs, 1.0),
          _toStringClean(rampWB.arm, 2.0),
          _toStringClean(rampWB.moment, 2.0), _getBorder(2.0, false, true), true));

      rows.add(_buildHeaderRow("Taxi fuel", _toStringClean(inputData[6].weightLbs, 1.0),
          _toStringClean(inputData[6].arm, 2.0),
          _toStringClean(inputData[6].moment, 2.0), _getBorder(2.0, false, true), false));

      rows.add(_buildHeaderRow("Takeoff weight", _toStringClean(takeoffWB.weightLbs, 1.0),
          _toStringClean(takeoffWB.arm, 2.0),
          _toStringClean(takeoffWB.moment, 2.0), _getBorder(2.0, false, true), true));
    }
    return rows;
  }

  String _toStringClean(double value, double roundDepth)
  {
    if (value==0.0) return "";
    double roundFactor = pow(10.0, roundDepth);
    return ((value * roundFactor).round().toDouble() / roundFactor).toString();
  }


  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: const EdgeInsets.all(8.0),
      color: Color(0xffCCFF66),
      child: Column(
        children: _getChidren(),
      )
    ));
  }
}
