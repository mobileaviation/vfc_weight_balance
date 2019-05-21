import 'conversions.dart';

class WBData {
  WBData.totalWB(double weight, double arm)
  {
    _unit = UnitType.Lbs;
    _weightType = WeightType.total;
    _value = weight;
    _weightLbs = weight;
    _arm = arm;
    _visible = true;
  }

  WBData.weightKg(double weight, double arm, WeightType type, String title, bool visible){
    _value = weight;
    _weightKg = weight;
    _weightLbs = KgToLbs(weight);
    _arm = arm;
    _title = title;
    _unit = UnitType.Kg;
    _weightType = type;
    _visible = visible;
  }

  WBData.fuelGal(double gal, double arm, String title, bool visible){
    _value = gal;
    _weightKg = GalToKgAvGas(gal);
    _weightLbs = GalToLbsAvGas(gal);
    _arm = arm;
    _title = title;
    _unit = UnitType.Gal;
    _weightType = WeightType.fuel;
    _visible = visible;
  }

  double get value { return _value; }
  set value(double newValue) {
    _value = newValue;
    if (_weightType==WeightType.fuel) {
      if (_unit==UnitType.Gal) {
        _weightKg = GalToKgAvGas(newValue);
        _weightLbs = GalToLbsAvGas(newValue);
      }
      // ToDo buildin support for Liters Fuel
    }
    if (_weightType==WeightType.person || _weightType==WeightType.bagage) {
      if (_unit==UnitType.Kg) {
        _weightKg = newValue;
        _weightLbs = KgToLbs(newValue);
      }
      // ToDo buildin support for LBS weigths
    }
  }
  double _value;
  double get gallons { return (_weightType==WeightType.fuel) ? _value : -1; }
  double get arm { return _arm; }
  double _arm;
  WeightType get weightType { return _weightType; }
  WeightType _weightType;
  double get weightKg { return _weightKg; }
  double _weightKg;
  double get weightLbs { return _weightLbs; }
  double _weightLbs;
  UnitType get unit { return _unit; }
  UnitType _unit;
  String get title { return _title; }
  set title(String newTitle) { _title = newTitle; }
  String _title;
  bool _visible;
  bool get visible { return _visible; }

  double get moment { return _weightLbs * _arm; }
}

enum WeightType {
  person,
  bagage,
  fuel,
  total
}

enum UnitType {
  Kg,
  Lbs,
  Liter,
  Gal
}