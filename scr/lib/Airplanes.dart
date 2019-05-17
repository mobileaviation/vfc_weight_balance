import 'dart:convert';
import 'airplane-defs.dart';

class Airplanes {
  Airplanes() {
    _airplanes = new List<Airplane>();
  }

  List<Airplane> _airplanes;

  Airplane getAirplaneByCallsign(String callsign)
  {
    String jsonStr = PHDRT;
    var ajson = json.decode(jsonStr);
    Airplane airplane = new Airplane.fromJson(ajson);
    return airplane;
  }
}

class Airplane {
  Airplane();

  String callsign;
  String type;
  double bew;
  double bewRound() { return ((bew/100).round()*100).toDouble(); }
  double beArm;
  double beMoment;
  double frontArm;
  double rearArm;
  double bagageArm;
  double feulArm;
  double maxFuel;
  double mrw;
  double mtow;
  double mtowRound() { return ((mtow/100).round()*100).toDouble(); }
  double fwd;
  double aft;
  double fwdW;
  double mtowFwd;
  double maxUtilW;
  double cgInc;
  double weightInc;

  factory Airplane.fromJson(Map<String, dynamic> json) {
    Airplane a = new Airplane();

    a.callsign = json['callsign'];
    a.type = json['type'];
    a.bew = json['bew'];
    a.beArm = json['beArm'];
    a.beMoment = json['beMoment'];
    a.frontArm = json['frontArm'];
    a.rearArm = json['rearArm'];
    a.bagageArm = json['bagageArm'];
    a.feulArm = json['feulArm'];
    a.maxFuel = json['maxFuel'];
    a.mrw = json['mrw'];
    a.mtow = json['mtow'];
    a.fwd = json['fwd'];
    a.aft = json['aft'];
    a.fwdW = json['fwdW'];
    a.mtowFwd = json['mtowFwd'];
    a.maxUtilW = json['maxUtilW'];
    a.cgInc = 1;
    a.weightInc = 100;

    return a;
  }
}