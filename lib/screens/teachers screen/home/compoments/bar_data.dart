

import 'individual_bar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tusAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tusAmount,
    required this.wedAmount,
    required this.thurAmount,
    required this.friAmount,
    required this.satAmount,
  });
  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: sunAmount),
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 0, y: tusAmount),
      IndividualBar(x: 0, y: wedAmount),
      IndividualBar(x: 0, y: thurAmount),
      IndividualBar(x: 0, y: friAmount),
      IndividualBar(x: 0, y: satAmount)
    ];
  }
}
