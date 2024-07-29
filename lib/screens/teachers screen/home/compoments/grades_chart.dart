import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';


class BarChartSample8 extends StatefulWidget {
  BarChartSample8({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: [
           kMediumHorizontalSpace,
                Text(
                  'Attendance Chart',
                  style:kMediumTextStyle,

                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: BarChart(
                randomData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y > 60 ? 60 : y,
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
          width: 30,
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: primaryColor, // Set the color of the left titles
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text = value.toInt().toString();

    return Text(text, style: style);
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: 60.0,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
            getTitlesWidget: getLeftTitles,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i,
          Random().nextInt(60).toDouble() + 10,
        ),
      ),
      gridData: FlGridData(show: false),
    );
  }
}
