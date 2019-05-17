import 'package:weight_and_balance/Airplanes.dart';
import 'InputPart.dart';
import 'conversions.dart';
import 'WBData.dart';

class CalculateWB {
  CalculateWB(List<WBData> this.inputData, Airplane this.airplane);

  List<WBData> inputData;
  Airplane airplane;

  WBData calculateTakeoffWB(int taxiWBIndex) {
    return _calculateWB(false, taxiWBIndex);
  }

  WBData calculateZeroFuelWB() {
    return _calculateWB(true, -1);
  }

  WBData calculateRampWB() {
    return _calculateWB(false, -1);
  }

  WBData _calculateWB(bool zfw, int substracktIndex) {
    double weight = airplane.bew;
    double moment = airplane.bew * airplane.beArm;
    for (int i=0; i<inputData.length; i++) {
      double w = inputData[i].weightLbs;
      double m = inputData[i].moment;

      if (zfw && inputData[i].weightType==WeightType.fuel){
        w = 0;
        m = 0;
      }

      if (i==substracktIndex) {
        w = w * -1;
        m = m * -1;
      }

      weight = weight + w;
      moment = moment + m;
    }

    double cg = moment / weight;
    WBData wb = new WBData.totalWB(weight, cg);
    return wb;
  }
}