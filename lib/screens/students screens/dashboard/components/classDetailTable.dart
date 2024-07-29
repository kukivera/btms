import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../constants.dart';
import '../../../../models/RecentFile.dart';


class ClassDetailTable extends StatelessWidget {
  const ClassDetailTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        height: 280,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: DataTable2(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              dataRowColor: MaterialStateProperty.all(secondaryColor),
               headingRowColor: MaterialStateProperty.all(primaryColor),
              headingRowDecoration: kMediumBoxDecoration,
              dividerThickness: 4,
              checkboxAlignment: Alignment.center,
              headingTextStyle: kMediumColoredBoldTextStyle,
              columns: [
                DataColumn2(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0), // Rounded at the start of the first column
                        bottomLeft: Radius.circular(10.0), // Rounded at the start of the first column
                      ),

                    ),
                    child: const Text("Class", style: kMediumColoredBoldTextStyle),
                  ),

                ),
                DataColumn2(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text("Exam Result", style: kMediumColoredBoldTextStyle),
                  ),
                ),
                DataColumn2(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0), // Rounded at the end of the last column
                        bottomRight: Radius.circular(10.0), // Rounded at the end of the last column
                      ),

                    ),
                    child: const Text("Attendance", style: kMediumColoredBoldTextStyle),
                  ),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                    (index) => DataRow2(
                      decoration: kMediumBoxDecoration.copyWith(
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(
                             0.0,
                              0.0,
                            ), //Offset
                            blurRadius: 0.0,
                            spreadRadius: 3.0,
                          ), //BoxShadow

                        ],
                      ),

                  cells: [
                    DataCell(
                      Text(demoRecentFiles[index].title!, style: kMediumColoredBoldTextStyle),
                    ),
                    DataCell(
                      Text(demoRecentFiles[index].date!,  style: kMediumColoredBoldTextStyle),
                    ),
                    DataCell(
                      Text(demoRecentFiles[index].size!,  style: kMediumColoredBoldTextStyle),
                    )
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}