import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyDashboard extends StatefulWidget {
  final List<String> xAxisList;
  final String xAxisName;
  final List<double> yAxisList;
  final String yAxisName;
  final double interval;

  const WeeklyDashboard(
      {super.key,
      required this.xAxisList,
      required this.yAxisList,
      required this.xAxisName,
      required this.yAxisName,
      required this.interval});

  @override
  _WeeklyDashboardState createState() => _WeeklyDashboardState();
}

class _WeeklyDashboardState extends State<WeeklyDashboard> {
  late List<String> xAxisList;
  late List<double> yAxisList;
  late String xAxisName;
  late String yAxisName;
  late double interval;

  @override
  void initState() {
    super.initState();
    xAxisList = widget.xAxisList;
    yAxisList = widget.yAxisList;
    xAxisName = widget.xAxisName;
    yAxisName = widget.yAxisName;
    interval = widget.interval;
  }

  Color? colorpicker(int? index) {
    if (index != null) {
      return index % 2 == 0
          ? const Color.fromRGBO(230, 210, 250, 1)
          : const Color.fromRGBO(120, 82, 174, 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Card(
            elevation: 10,
            shadowColor: Colors.grey,
            color: Colors.white,
            child: SizedBox(
                height: screenHeight * 0.33,
                width: screenWidth * 0.90,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: BarChart(BarChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              bottomTitles(value, meta, xAxisList),
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: interval,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        left: BorderSide.none,
                        bottom: BorderSide(
                            width: 1, color: Color.fromRGBO(173, 172, 172, 1)),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    barGroups: List.generate(
                      xAxisList.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                              toY: yAxisList[index],
                              width: 20,
                              color: colorpicker(index),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5))),
                        ],
                      ),
                    ).toList(),
                  )),
                ))));
  }
}

Widget bottomTitles(
    double value, TitleMeta meta, List<String> bottomTilesData) {
  final Widget text = Text(
    bottomTilesData[value.toInt()],
    style: const TextStyle(color: Colors.grey, fontSize: 7),
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 14,
    child: text,
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  final formattedValue = (value).toStringAsFixed(0);
  final Widget text = Text(
    formattedValue,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 7,
    ),
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 14,
    child: text,
  );
}
