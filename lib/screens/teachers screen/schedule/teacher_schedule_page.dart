import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../widgets/calender_widget.dart';
import '../../../widgets/header.dart';
import '../../main/sidemenus/side menus/student_side_menu.dart';
import '../../students screens/dashboard/components/classDetailTable.dart';

class TeachersSchedule extends StatefulWidget {
  const TeachersSchedule({super.key});

  @override
  State<TeachersSchedule> createState() => _TeachersScheduleState();
}

class _TeachersScheduleState extends State<TeachersSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Header(title: 'Schedule',),
                  SizedBox(height: defaultPadding),
                  Text(
                    "Teachers Schedule Screen",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Calendar(),
                  ClassDetailTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
