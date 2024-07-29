import 'package:bruh_finance_tms/widgets/chartDiscription/ChartDescription.dart';
import 'package:bruh_finance_tms/widgets/charts.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';



class AttendanceOverview extends StatelessWidget {
  const AttendanceOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: defaultPadding),
          Chart(title: 'Student attendance', description: 'Overall student attendance percentage', percentage: 75,),
         ChartDescription(done: 'Present', undone: 'Absent')
        ],
      ),
    );
  }
}
