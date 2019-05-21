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

    a.callsign = json['call_sign'];
    a.type = json['type'];
    a.bew = json['bew'].toDouble();
    a.beArm = json['beArm'].toDouble();
    a.beMoment = json['beMoment'].toDouble();
    a.frontArm = json['frontArm'].toDouble();
    a.rearArm = json['rearArm'].toDouble();
    a.bagageArm = json['bagageArm'].toDouble();
    a.feulArm = json['feulArm'].toDouble();
    a.maxFuel = json['maxFuel'].toDouble();
    a.mrw = json['mrw'].toDouble();
    a.mtow = json['mtow'].toDouble();
    a.fwd = json['fwd'].toDouble();
    a.aft = json['aft'].toDouble();
    a.fwdW = json['fwdW'].toDouble();
    a.mtowFwd = json['mtowFwd'].toDouble();
    a.maxUtilW = json['maxUtilW'].toDouble();
    a.cgInc = 1;
    a.weightInc = 100;

    return a;
  }
}