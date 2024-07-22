import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/bar_data.dart';

class CustomGraph extends StatelessWidget {
  final List<double> data;
  const CustomGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    BarData myData = BarData(
        monSteps: data[0],
        tueSteps: data[1],
        wedSteps: data[2],
        thuSteps: data[3],
        friSteps: data[4],
        satSteps: data[5],
        sunSteps: data[6]);

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
        'MON',
        style: style,
      );
      break;

    case 1:
      text = const Text(
        'TUE',
        style: style,
      );
      break;
    case 2:
      text = const Text(
        'WED',
        style: style,
      );
      break;

    case 3:
      text = const Text(
        'THU',
        style: style,
      );
      break;

    case 4:
      text = const Text(
        'FRI',
        style: style,
      );
      break;

    case 5:
      text = const Text(
        'SAT',
        style: style,
      );
      break;

    default:
      text = const Text(
        'SUN',
        style: style,
      );
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
