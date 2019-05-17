import 'package:flutter/material.dart';
import 'InputPart.dart';
import 'WBData.dart';

class WeightInput extends StatefulWidget {
  WeightInput({Key key, this.onInputDataChanged, this.inputData}) : super(key: key);

  List<WBData> inputData;

  ValueChanged< List<WBData> > onInputDataChanged;

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  void _sendData(WBData data)
  {
    widget.onInputDataChanged(widget.inputData);
  }

  @override
  Widget build(BuildContext context) {
    String _dialogtext = "Select Weight in Kg";
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InputPart(
              data: widget.inputData[0],
              dialogText: _dialogtext,
              min: 20,
              max: 150,
              onInputdataChanged: _sendData,
            ),
            InputPart(
              data: widget.inputData[1],
              dialogText: _dialogtext,
              min: 0,
              max: 150,
              onInputdataChanged: _sendData,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InputPart(
              data: widget.inputData[2],
              dialogText: _dialogtext,
              min: 0,
              max: 150,
              onInputdataChanged: _sendData,
            ),
            InputPart(
              data: widget.inputData[3],
              dialogText: _dialogtext,
              min: 0,
              max: 150,
              onInputdataChanged: _sendData,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InputPart(
              data: widget.inputData[4],
              dialogText: _dialogtext,
              min: 0,
              max: 50,
              onInputdataChanged: _sendData,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InputPart(
              data: widget.inputData[5],
              dialogText: "Select Fuel in Gal",
              min: 0,
              max: 48,
              onInputdataChanged: _sendData,
            ),
          ],
        ),
      ],
    );
  }
}
