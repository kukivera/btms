import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Added Payments', style: TextStyle(
            color: Colors.black,
          fontSize: 18,
        ),),
        Text(' You have paid 80,000.00 Etb \n 40,000.00 Etb pending', style: TextStyle(
            color: Colors.black,
          fontSize: 14,

        ),),
        SizedBox(height: 40,),
        SizedBox(
          height: 200,
          child: Stack(
            children: [


              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  sections: paiChartSelectionData,
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: defaultPadding),
                    Text(
                      "75 %",
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
    );
  }
}

List<PieChartSectionData> paiChartSelectionData = [
  PieChartSectionData(
    color: primaryColor,
    value: 75 ,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Colors.white,
    value: 25 ,
    showTitle: false,
    radius: 25,
  ),

];
