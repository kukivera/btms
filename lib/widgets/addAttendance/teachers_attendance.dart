import 'package:bruh_finance_tms/constants.dart';

import 'package:bruh_finance_tms/widgets/course_dropdown/program_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../header.dart';

class Instructor {
  String name;
  List<Class> classes;

  Instructor({required this.name, required this.classes});
}

class Class {
  String name;
  bool morningAttendance;
  bool afternoonAttendance;

  Class({required this.name, this.morningAttendance = false, this.afternoonAttendance = false});
}

class AttendanceTable extends StatefulWidget {
  const AttendanceTable({Key? key});

  @override
  _AttendanceTableState createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  List<Instructor> instructors = [
    Instructor(name: 'John Doe', classes: [
      Class(name: 'Class 1'),
      Class(name: 'Class 2'),
      Class(name: 'Class 3'),
      Class(name: 'Class 4'),
    ]),
    Instructor(name: 'Jane Smith', classes: [
      Class(name: 'Class 1'),
      Class(name: 'Class 2'),
      Class(name: 'Class 3'),
      Class(name: 'Class 4'),
    ]),
    // Add more instructors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Header(title: 'Teachers Attendance',),
          const ProgramDropdown(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Instructor', style: kSmallTextStyle)),
                DataColumn(label: Text('Class', style: kSmallTextStyle)),
                DataColumn(label: Text('Morning', style: kSmallTextStyle)),
                DataColumn(label: Text('Afternoon', style: kSmallTextStyle)),
                DataColumn(label: Text('Update', style: kSmallTextStyle)),
              ],
              rows: instructors.expand((instructor) {
                return instructor.classes.map((classItem) {
                  return DataRow(cells: [
                    DataCell(Text(instructor.name, style: kSmallTextStyle)),
                    DataCell(Text(classItem.name, style: kSmallTextStyle)),
                    DataCell(
                      Checkbox(
                        value: classItem.morningAttendance,
                        onChanged: (value) {
                          setState(() {
                            classItem.morningAttendance = value!;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: classItem.afternoonAttendance,
                        onChanged: (value) {
                          setState(() {
                            classItem.afternoonAttendance = value!;
                          });
                        },
                      ),
                    ),
                    DataCell(UpdateButton()), // Update button for each class
                  ]);
                });
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle update button action
        print('Update button pressed');
      },
      child: const Text('Update'),
    );
  }
}