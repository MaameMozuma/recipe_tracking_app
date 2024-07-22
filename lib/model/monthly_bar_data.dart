import 'package:team_proj_leanne/model/individual_bar.dart';

class MonthlyBarData {
  final double weekOneSteps;
  final double weekTwoSteps;
  final double weekThreeSteps;
  final double weekFourSteps;
  final double? weekFiveSteps;

  MonthlyBarData(
      {
      required this.weekOneSteps,
      required this.weekTwoSteps,
      required this.weekThreeSteps,
      required this.weekFourSteps,
      this.weekFiveSteps,
      });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: weekOneSteps),
      IndividualBar(x: 1, y: weekTwoSteps),
      IndividualBar(x: 2, y: weekThreeSteps),
      IndividualBar(x: 3, y: weekFourSteps),
      if (weekFiveSteps != null) IndividualBar(x: 4, y: weekFiveSteps!),
    ];
  }
}
