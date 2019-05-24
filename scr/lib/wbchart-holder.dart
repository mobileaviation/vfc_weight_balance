import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'calculate_wb.dart';
import 'dart:ui';
import 'Airplanes.dart';
import 'wbchart.dart';
import 'WBData.dart';
import 'dart:ui' as ui;

class WBChartHolder extends CustomPainter {
  WBChartHolder(Airplane this.airplane, WBData this.takeoffWB, WBData this.zeroFeulWB) {}

  Airplane airplane;
  WBData takeoffWB;
  WBData zeroFeulWB;

  final int _padding = 8;

  Future getImageData(Airplane airplane, WBData takeoffWB, WBData zeroFuelWB, Size size) async {
    var recorder = new ui.PictureRecorder();
    var origin = new Offset(0.0, 0.0);
    var paintBounds = new Rect.fromPoints(size.topLeft(origin), size.bottomRight(origin));
    var canvas = new Canvas(recorder, paintBounds);
    _doPaint(airplane, takeoffWB, zeroFuelWB, canvas, size);
    var picture = recorder.endRecording();
    var image = await picture.toImage(size.width.round(), size.height.round());
    return image;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _doPaint(airplane, takeoffWB, zeroFeulWB, canvas, size);
  }
  
  void _doPaint(Airplane airplane, WBData takeoffWB, WBData zeroFuelWB, Canvas canvas, Size size)
  {
    Paint bgPaint = new Paint()
      ..color = Color(0xffCCFF66)
      ..style = PaintingStyle.fill;

    canvas.drawRect(new Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    double p = _getPadding(size);
    Rect chartRect = new Rect.fromLTWH(p, p, size.width - (p*2), size.height - (p*2));

    WBChart chart = new WBChart(airplane, takeoffWB, zeroFeulWB);
    chart.paint(canvas, chartRect);
  }

  double _getPadding(Size size)
  {
    return size.width / _padding;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}