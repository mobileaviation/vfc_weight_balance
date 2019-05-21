import 'package:flutter/material.dart';
import 'package:weight_and_balance/calculate_wb.dart';
import 'dart:ui';
import 'Airplanes.dart';
import 'wbchart.dart';
import 'WBData.dart';

class WBChartHolder extends CustomPainter {
  WBChartHolder(Airplane this.airplane, WBData this.takeoffWB, WBData this.zeroFeulWB) {}

  Airplane airplane;
  WBData takeoffWB;
  WBData zeroFeulWB;

  final int _padding = 8;

  @override
  void paint(Canvas canvas, Size size) {
    //print(airplane);

    // TODO: implement paint
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