import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.title,
    required this.description,
    required this.percentage,
  });

  final String title;
  final String description;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kMediumTextStyle),
          Text(description, style: kSmallTextStyle),
          kLargeVerticalSpace,
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    startDegreeOffset: -90,
                    sections: _buildPieChartSections(percentage),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: defaultPadding),
                      Text(
                        "$percentage %",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w300,
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(int percentage) {
    final double presentPercentage = percentage.toDouble();
    final double absentPercentage = 100 - presentPercentage;

    return [
      PieChartSectionData(
        color: primaryColor,
        value: presentPercentage,
        title: '$presentPercentage%',
        showTitle: false,
        radius: 25,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: absentPercentage,
        title: '$absentPercentage%',
        showTitle: false,
        radius: 25,
      ),
    ];
  }
}