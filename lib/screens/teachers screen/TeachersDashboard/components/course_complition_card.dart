import 'package:bruh_finance_tms/screens/teachers%20screen/TeachersDashboard/components/teachers_dashboard_cards.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../widgets/ProgressLine/ProgressLine.dart';

class CourseComplitionCard extends StatelessWidget {
  const CourseComplitionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TeacherDashboardCards(
      content: Padding(
        padding: EdgeInsets.all(16.0),
        child: CourseCompletion(),
      ),
    );
  }
}

class CourseCompletion extends StatelessWidget {
  const CourseCompletion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Course Completion',
          style: kMediumColoredTextStyle.copyWith(fontSize: 16),
        ),
        Text(
          'Award in General Insurance',
          style: kMediumColoredBoldTextStyle.copyWith(fontSize: 18),
        ),
        const ProgressLine(
          percentage: 75,
          color: primaryColor,
          hight: 30,
        ),
      ],
    );
  }
}