import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/monthly_bar_data.dart';

class CustomMonthlyGraph extends StatelessWidget {
  final List<double> data;
  const CustomMonthlyGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    MonthlyBarData myData = MonthlyBarData(
      weekOneSteps: data[0],
      weekTwoSteps: data[1],
      weekThreeSteps: data[2],
      weekFourSteps: data[3],
      weekFiveSteps: data.length > 4 ? data[4] : null,
    );

    myData.initializeBarData();
    final double maxDataValue = data.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maxDataValue * 1.2,
        minY: 0,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: const FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: getBottomTitles))),
        barGroups: myData.barData
            .asMap() // Convert to map to get index
            .map(
              (index, data) => MapEntry(
                index,
                BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      color: index.isEven
                          ? const Color.fromARGB(255, 230, 230, 250)
                          : const Color.fromARGB(
                              255, 120, 82, 174), // Conditional color
                      width: 25,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: false, toY: 12, color: Colors.grey[200]),
                    ),
                  ],
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        'WK 1',
        style: style,
      );
      break;

    case 1:
      text = const Text(
        'WK 2',
        style: style,
      );
      break;
    case 2:
      text = const Text(
        'WK 3',
        style: style,
      );
      break;

    case 3:
      text = const Text(
        'WK 4',
        style: style,
      );
      break;

    default:
      text = const Text(
        'WK 5',
        style: style,
      );
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
