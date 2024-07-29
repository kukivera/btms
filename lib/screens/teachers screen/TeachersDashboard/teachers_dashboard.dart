import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';
import '../../../responsive.dart';
import '../../../widgets/header.dart';
import '../../../widgets/program_dropdown/program_dropdown.dart';
import 'components/course_complition_card.dart';
import 'components/schedule_viewer.dart';
import 'components/student_attendance.dart';
import 'components/test_part_rate.dart';
import 'components/updates.dart';

class TeachersDashboard1 extends StatefulWidget {
  const TeachersDashboard1({super.key});

  @override
  State<TeachersDashboard1> createState() => _TeachersDashboard1State();
}

class _TeachersDashboard1State extends State<TeachersDashboard1> {
  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all<Color>(
              primaryColor), // Set the color of the scrollbar thumb
          radius: const Radius.circular(
              4.0), // Set the radius of the scrollbar thumb
        ),
        child: Scrollbar(
            thumbVisibility: true, // Set to true to always show the scrollbar
            thickness: 8.0, // Set the thickness of the scrollbar
            radius: const Radius.circular(
                4.0), // Set the radius of the scrollbar thumb
            controller:
                ScrollController(), // Use a ScrollController to control the scroll position
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Header(
                      title: 'Dashboard',
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ProgramDropdownPro(),
                    ),
                    kSmallVerticalSpace,
                    if (Responsive.isDesktop(context))
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CourseComplitionCard(),
                            student_attendance(),
                            TestPassRate(),
                          ],
                        ),
                      ),
                    if (!Responsive.isDesktop(context)) CourseComplitionCard(),
                    if (!Responsive.isDesktop(context)) student_attendance(),
                    if (!Responsive.isDesktop(context)) TestPassRate(),
                    if (Responsive.isDesktop(context))
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Updates(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ScheduleViewer(),
                            )
                          ],
                        ),
                      ),
                    if (!Responsive.isDesktop(context)) Updates(),
                    if (!Responsive.isDesktop(context)) ScheduleViewer(),
                  ],
                ),
              ),
            )));
  }
}
