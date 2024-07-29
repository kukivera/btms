

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../models/RecentFile.dart';

class ClassDetailTable extends StatelessWidget {
  const ClassDetailTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Files",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Class", style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
                DataColumn(
                  label: Text("Exam Result", style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
                DataColumn(
                  label: Text("Attendance", style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(ClassDetail fileInfo) {
  return DataRow(
    cells: [
      DataCell( Text(fileInfo.title!, style: TextStyle(
                color: Colors.black, ),),
            ),


      DataCell(Text(fileInfo.date!, style: TextStyle(
        color: Colors.black,
      ),)),
      DataCell(Text(fileInfo.size!, style: TextStyle(
        color: Colors.black,
      ),)),
    ],
  );
}
