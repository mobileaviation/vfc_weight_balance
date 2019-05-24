import 'dart:ui';
import 'package:flutter/material.dart';
import 'calculate_wb.dart';
import 'Airplanes.dart';
import 'package:angles/angles.dart';
import 'WBData.dart';

class WBChart {
  WBChart(Airplane this.airplane, WBData this.takeoffWB, WBData this.zeroFeulWB);
  Airplane airplane;
  WBData takeoffWB;
  WBData zeroFeulWB;

  double _weightToY(Rect rect, double weight) {
    double weightSize = (airplane.mtowRound() + airplane.weightInc) - (airplane.bewRound() - airplane.weightInc);
    double weightFactor = (weight - (airplane.bewRound() - airplane.weightInc)) / weightSize;
    return rect.height-(rect.height * weightFactor);
  }

  double _chToX(Rect rect, double cg)
  {
    double cgSize = (airplane.aft + airplane.cgInc) - (airplane.fwd - airplane.cgInc);
    double cfFactor = (cg - (airplane.fwd - airplane.cgInc)) / cgSize;
    return rect.width * cfFactor;
  }

  Offset _getAbsOffset(Rect rect, double x, double y)
  {
    return new Offset(rect.left + x, rect.top + y);
  }

  Offset _getOffset(Rect rect, double cg, double weight)
  {
    double x = _chToX(rect, cg );
    double y = _weightToY(rect, weight);
    return _getAbsOffset(rect, x, y);
  }

  Paint _getLinePaint()
  {
    return new Paint()
      ..color = Colors.black
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.square;
  }

  void _drawTextrotate(String text, Offset position, Canvas canvas, double rotate, Rect rect)
  {
    canvas.save();
    canvas.translate(rect.width/2, rect.height/2);
    Angle r = Angle.fromDegrees(rotate);
    canvas.rotate(r.radians);

    _drawText(text, 9, position, canvas);

    canvas.restore();
  }
  
  void _drawText(String text, double size, Offset position, Canvas canvas)
  {
    TextSpan span = new TextSpan(style: new TextStyle(
          color: Colors.black,
          fontSize: size,
          fontFamily: 'Oxygen',
          fontWeight: FontWeight.normal
          ),
        text: text);
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, position);

  }

  void _drawTopText(String text, double size, Rect rect, Canvas canvas)
  {
    TextSpan span = new TextSpan(style: new TextStyle(
        color: Colors.black,
        fontSize: size,
        fontFamily: 'Oxygen',
        fontWeight: FontWeight.bold,
    ),
        text: text);
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout(minWidth: rect.width);
      Offset p = _getAbsOffset(rect, 0, -27);
      tp.paint(canvas, p);
  }

  void _drawWeightGrid(Rect rect, Canvas canvas)
  {
    Paint linePaint = _getLinePaint();
    for (double h = airplane.bewRound()-airplane.weightInc; h<=airplane.mtowRound()+airplane.weightInc; h+=airplane.weightInc) {
      double y =  _weightToY(rect, h);
      Offset s1 = _getAbsOffset(rect, 0, y);
      Offset s2 = _getAbsOffset(rect, rect.width, y);
      linePaint.strokeWidth = 0.3;
      canvas.drawLine(s1, s2, linePaint);
      linePaint.strokeWidth = 0.5;
      canvas.drawLine(_getAbsOffset(rect, -5, y), s2, linePaint);
      _drawText(h.round().toString(), 9, _getAbsOffset(rect, -30, y-5), canvas);
    }
  }

  void _drawCGGrid(Rect rect, Canvas canvas)
  {
    Paint linePaint = _getLinePaint();
    for (double h = airplane.fwd - airplane.cgInc; h<=airplane.aft + airplane.cgInc; h+=airplane.cgInc) {
      double x =  _chToX(rect, h);
      Offset s1 = _getAbsOffset(rect, x, 0);
      Offset s2 = _getAbsOffset(rect, x, rect.height + 5);
      linePaint.strokeWidth = 0.3;
      canvas.drawLine(s1, s2, linePaint);
      linePaint.strokeWidth = 0.5;
      canvas.drawLine(_getAbsOffset(rect, x, 0), s2, linePaint);
      _drawText(h.round().toString(), 9, _getAbsOffset(rect, x-5, rect.height+5), canvas);
    }
  }

  Gradient _getShader()
  {
    // a fancy rainbow gradient
    final Gradient gradient = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFF58D3FF),
        Color(0xFFFCEAF9),
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    return gradient;
  }

  void _drawEnvelope(Rect rect, Canvas canvas)
  {
    Paint evelopePaint = new Paint()
      ..color = Color(0xFFC00000)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    Offset pos1 = _getOffset(rect, airplane.fwd , airplane.bew);
    Offset pos2 = _getOffset(rect, airplane.aft, airplane.bew);
    Offset pos3 = _getOffset(rect, airplane.aft, airplane.mtow);
    Offset pos4 = _getOffset(rect, airplane.mtowFwd, airplane.mtow);
    Offset pos5 = _getOffset(rect, airplane.fwd, airplane.fwdW);

    double a = airplane.mtow - airplane.fwdW;
    double b = airplane.mtowFwd - airplane.fwd;
    double d = airplane.maxUtilW - airplane.fwdW;
    double util_fwd = (b / a) * d;
    util_fwd = airplane.fwd + util_fwd;

    //double util_fwd = airplane.fwd + ((airplane.mtow-airplane.fwdW) / ((airplane.maxUtilW-airplane.fwdW) * (airplane.mtowFwd-airplane.fwd)));
    Offset pos7 = _getOffset(rect, util_fwd, airplane.maxUtilW);
    Offset pos8 = _getOffset(rect, airplane.aft, airplane.maxUtilW);

    canvas.drawLine(pos1, pos2, evelopePaint);
    canvas.drawLine(pos2, pos3, evelopePaint);
    canvas.drawLine(pos3, pos4, evelopePaint);
    canvas.drawLine(pos4, pos5, evelopePaint);
    canvas.drawLine(pos5, pos1, evelopePaint);
    canvas.drawLine(pos7, pos8, evelopePaint);

    canvas.drawRect(Rect.fromLTWH(pos1.dx-3, pos1.dy-3, 7, 7), evelopePaint);
    canvas.drawRect(Rect.fromLTWH(pos2.dx-3, pos2.dy-3, 7, 7), evelopePaint);
    canvas.drawRect(Rect.fromLTWH(pos3.dx-3, pos3.dy-3, 7, 7), evelopePaint);
    canvas.drawRect(Rect.fromLTWH(pos4.dx-3, pos4.dy-3, 7, 7), evelopePaint);
    canvas.drawRect(Rect.fromLTWH(pos5.dx-3, pos5.dy-3, 7, 7), evelopePaint);
    canvas.drawRect(Rect.fromLTWH(pos7.dx-3, pos7.dy-3, 7, 7), evelopePaint);
    canvas.drawRect(Rect.fromLTWH(pos8.dx-3, pos8.dy-3, 7, 7), evelopePaint);

  }

  void _drawWbPosition(Canvas canvas, Rect rect, Color color, WBData wb) {
    Offset t = _getOffset(rect, wb.arm, wb.weightLbs);
    Paint wbPosPaint = new Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = .5;
    canvas.drawCircle(t, 4, wbPosPaint);
    wbPosPaint.style = PaintingStyle.stroke;
    wbPosPaint.color = Colors.black;
    canvas.drawCircle(t, 4, wbPosPaint);
    Offset t1 = new Offset(t.dx + 7, t.dy - 5);
    _drawText(wb.title, 10, t1, canvas);
  }

  void paint(Canvas canvas, Rect rect)
  {
    final Paint paint = new Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..shader = _getShader().createShader(rect);
    canvas.drawRect(rect, paint);

    Paint linePaint = _getLinePaint();

    canvas.drawLine(_getAbsOffset(rect, -5, rect.height), _getAbsOffset(rect, rect.width + 5, rect.height), linePaint);
    canvas.drawLine(_getAbsOffset(rect, rect.width, rect.height + 5), _getAbsOffset(rect, rect.width, - 5), linePaint);
    canvas.drawLine(_getAbsOffset(rect, rect.width + 5, 0), _getAbsOffset(rect, -5, 0), linePaint);
    canvas.drawLine(_getAbsOffset(rect, 0, -5), _getAbsOffset(rect, 0, rect.height + 5), linePaint);

    _drawWeightGrid(rect, canvas);
    _drawCGGrid(rect, canvas);

    _drawTextrotate("Weight (lbs)", _getAbsOffset(rect, -(rect.height/2) + 20, -(rect.width/2) - 42), canvas, 270, rect);
    _drawText("CG Location (in)", 9,_getAbsOffset(rect, (rect.width/2) - 30 , rect.height + 15), canvas);

    _drawEnvelope(rect, canvas);

    if (takeoffWB != null)
      _drawWbPosition(canvas, rect, Color(0xFF00FF00), takeoffWB);

    if (zeroFeulWB != null)
      _drawWbPosition(canvas, rect, Color(0xFFFFC000), zeroFeulWB);

    _drawTopText("Weight & Balance evelope: " + airplane.callsign, 11, rect, canvas);
  }


}