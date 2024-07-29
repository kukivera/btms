import 'package:bruh_finance_tms/screens/admin%20screens/admin_dashboard/multicolor_chart/multiColorCharts.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/admin_dashboard/multicolor_chart/user_details_widget.dart';
import 'package:bruh_finance_tms/widgets/charts.dart';
import 'package:flutter/material.dart';

import '../../../responsive.dart';
import '../../../widgets/course_dropdown/program_dropdown.dart';
import '../../../widgets/header.dart';
import '../../main/sidemenus/side menus/student_side_menu.dart';

import 'compoments/attendance_chart.dart';
import 'compoments/grades_chart.dart';



class TeachersDashboard extends StatefulWidget {
  const TeachersDashboard({super.key});

  @override
  State<TeachersDashboard> createState() => _TeachersDashboardState();
}

class _TeachersDashboardState extends State<TeachersDashboard> {
  // List<double> weeklySummery = [10, 20, 30, 40, 50, 60, 70];
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Header(title: 'Dashboard',),
                    SizedBox(height: 20),
                    ProgramDropdown(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                              height: 600, width: 700, child: BarChartSample8()),
                        ),
                        Expanded(
                            flex: 1,

                            child: Container(child: UserDetailsWidget()))
                      ],
                    )
                  ],
                ),
              ),
    );
  }
}
