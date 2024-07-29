
import 'package:bruh_finance_tms/screens/teachers%20screen/TeachersDashboard/components/teachers_dashboard_cards.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../widgets/ProgressLine/ProgressLineDoubleTect.dart';



class student_attendance extends StatelessWidget {
  const student_attendance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TeacherDashboardCards(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Student Attendance',
              style: kMediumColoredTextStyle.copyWith(fontSize: 18),
            ),
            const ProgressLineDoubleText(
                color: primaryColor,
                percentage: 100,
                height: 20,
                description: 'Class 1'),
            const ProgressLineDoubleText(
                color: primaryColor,
                percentage: 100,
                height: 20,
                description: 'Class 1'),
            const ProgressLineDoubleText(
                color: primaryColor,
                percentage: 50,
                height: 20,
                description: 'Class 1'),
            const ProgressLineDoubleText(
                color: primaryColor,
                percentage: 00,
                height: 20,
                description: 'Class 1')
          ],
        ),
      ),
    );
  }
}