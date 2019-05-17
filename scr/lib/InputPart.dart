import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'wb_text.dart';
import 'WBData.dart';

class InputPart extends StatefulWidget {
  InputPart({Key key, this.data, this.dialogText, this.min, this.max, this.onInputdataChanged}) : super(key: key);
  WBData data;
  String dialogText;
  int min;
  int max;
  ValueChanged<WBData> onInputdataChanged;


  @override
  _InputPartState createState() => _InputPartState();
}

class _InputPartState extends State<InputPart> {
  _InputPartState();

  Widget _getButton() {
    return (RaisedButton(
      onPressed: () => _showWeightDialog(),
      child: getTextSize11( widget.data.value.round().toString() + " " + widget.data.unit.toString().split('.')[1]),
      color: Color(0xFF58D3FF),
    ));
  }

  void _showWeightDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
              title: getTextDialog( widget.dialogText ),
              minValue: widget.min,
              maxValue: widget.max,
              initialIntegerValue: widget.data.value.round());
        }).then((int value) {
      if (value != null) {
        setState(() {
          widget.data.value = value.toDouble();
        });
        widget.onInputdataChanged(widget.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          margin: EdgeInsets.only(left: 10),
          child: getTextSize11(widget.data.title),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
          height: 25,
          child: _getButton(),
        ),
      ],
    );
  }
}