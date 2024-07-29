import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:bruh_finance_tms/responsive.dart';

import '../../screens/admin screens/student_teacher_attendance/components/profile_page.dart';
class CustomDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> students;

  const CustomDataTable({
    Key? key,
    required this.students,
  }) : super(key: key);

  Widget _buildStatusCheckbox(String status) {
    return status == 'Present'
        ? const Icon(Icons.check, color: Colors.green)
        : const Icon(Icons.close, color: Colors.red);
  }

  double calculatePercentage(Map<String, dynamic> student) {
    final presentCount = [
      student['class1'],
      student['class2'],
      student['class3'],
      student['class4']
    ].where((status) => status == 'Present').length;
    const totalClasses = 4;
    return (presentCount / totalClasses) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        border: const TableBorder(top: BorderSide(color: Colors.blue, width: 5), bottom: BorderSide(color: Colors.blue, width: 1)),
      headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.lightBlue,
      ),
      // dividerThickness: 0.0, // Remove the lines between rows
      // border: TableBorder.all(color: Colors.transparent), // Invisible column lines
      columns:  [
        const DataColumn(
          label: Text('Name', style:kSmallTextStyle ),
        ),
        const DataColumn(
          label: Text('Phone', style:kSmallTextStyle ),
        ),
        if (Responsive.isDesktop(context))  const DataColumn(
          label: Text('Class 1', style:kSmallTextStyle ),
        ),
        if (Responsive.isDesktop(context))  const DataColumn(
          label: Text('Class 2', style:kSmallTextStyle ),
        ),
        if (Responsive.isDesktop(context))  const DataColumn(
          label: Text('Class 3', style:kSmallTextStyle ),
        ),
        if (Responsive.isDesktop(context))  const DataColumn(
          label: Text('Class 4', style:kSmallTextStyle ),
        ),
        const DataColumn(
          label: Text('Percentage', style:kSmallTextStyle ),
        ),
      ],
      rows: students.map((student) {
        return DataRow(
          cells: [
            DataCell(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        name: student['name'],
                        phone: student['phone'],
                      ),
                    ),
                  );
                },
                child: Text(
                  student['name'],
                  style: kSmallTextStyle,
                ),
              ),
            ),
            DataCell(
              Text(
                student['phone'],
                style: kSmallTextStyle,
              ),
            ),
            if (Responsive.isDesktop(context)) DataCell(_buildStatusCheckbox(student['class1'])),
            if (Responsive.isDesktop(context)) DataCell(_buildStatusCheckbox(student['class2'])),
            if (Responsive.isDesktop(context)) DataCell(_buildStatusCheckbox(student['class3'])),
            if (Responsive.isDesktop(context)) DataCell(_buildStatusCheckbox(student['class4'])),
            DataCell(
              Text(
                '${calculatePercentage(student).toStringAsFixed(2)}%',
                style: kSmallTextStyle,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}