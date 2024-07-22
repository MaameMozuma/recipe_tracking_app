import 'package:team_proj_leanne/model/individual_bar.dart';

class BarData {
  final double monSteps;
  final double tueSteps;
  final double wedSteps;
  final double thuSteps;
  final double friSteps;
  final double satSteps;
  final double sunSteps;

  BarData(
      {
      required this.monSteps,
      required this.tueSteps,
      required this.wedSteps,
      required this.thuSteps,
      required this.friSteps,
      required this.satSteps,
      required this.sunSteps,
      });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: monSteps),
      IndividualBar(x: 1, y: tueSteps),
      IndividualBar(x: 2, y: wedSteps),
      IndividualBar(x: 3, y: thuSteps),
      IndividualBar(x: 4, y: friSteps),
      IndividualBar(x: 5, y: satSteps),
      IndividualBar(x: 6, y: sunSteps),
    ];
  }
}
