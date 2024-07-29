import 'package:bruh_finance_tms/screens/teachers%20screen/TeachersDashboard/components/teachers_dashboard_cards.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../widgets/ProgressLine/ProgressLineDoubleTect.dart';


class TestPassRate extends StatelessWidget {
  const TestPassRate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TeacherDashboardCards(
      content: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Test Pass Rate',style: kLargeColoredBoldTextStyle,),
            ProgressLineDoubleText(color: primaryColor, percentage: 100, height: 20, description: 'test-1'),
            ProgressLineDoubleText(color: primaryColor, percentage: 80, height: 20, description: 'test-2'),
            ProgressLineDoubleText(color: primaryColor, percentage: 0, height: 20, description: 'test-3'),
            ProgressLineDoubleText(color: primaryColor, percentage: 0, height: 20, description: 'test-4')
          ],

        ),
      ),
    );
  }
}