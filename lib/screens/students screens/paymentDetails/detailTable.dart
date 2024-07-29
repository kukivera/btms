import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../constants.dart';

class ClassDetailTableMain extends StatelessWidget {
  const ClassDetailTableMain({
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:  DataTable2(
          decoration: const BoxDecoration(
            // color: Colors.white,
          ),
          dataRowColor: MaterialStateProperty.all(primaryColor),
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          headingRowDecoration: kMediumBoxDecoration,
          dividerThickness: 4,
          checkboxAlignment: Alignment.center,
          columns: [
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        10.0), // Rounded at the start of the first column
                    bottomLeft: Radius.circular(
                        10.0), // Rounded at the start of the first column
                  ),
                ),
                child: const Text("No", style: kTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        10.0), // Rounded at the start of the first column
                    bottomLeft: Radius.circular(
                        10.0), // Rounded at the start of the first column
                  ),
                ),
                child: const Text("Program", style: kTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text("Paid By", style: kTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                        10.0), // Rounded at the end of the last column
                    bottomRight: Radius.circular(
                        10.0), // Rounded at the end of the last column
                  ),
                ),
                child: const Text("Fee", style: kTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                        10.0), // Rounded at the end of the last column
                    bottomRight: Radius.circular(
                        10.0), // Rounded at the end of the last column
                  ),
                ),
                child: const Text("Outstanding", style: kTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                        10.0), // Rounded at the end of the last column
                    bottomRight: Radius.circular(
                        10.0), // Rounded at the end of the last column
                  ),
                ),
                child: const Text("Paid", style: kTextStyle),
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
                  Text((index + 1).toString(), style: kTextStyle),
                ),
                DataCell(
                  Text(demoRecentFiles[index]['program'], style: kTextStyle),
                ),
                DataCell(
                  Text(demoRecentFiles[index]['paidBy'], style: kTextStyle),
                ),
                DataCell(
                  Text(demoRecentFiles[index]['fee'].toString(),
                      style: kTextStyle),
                ),
                DataCell(
                  Text(demoRecentFiles[index]['outstanding'].toString(),
                      style: kTextStyle),
                ),
                DataCell(
                  Text(demoRecentFiles[index]['paid'].toString(),
                      style: kTextStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgramDetail {
  final String? program, paidBy, fee, outstanding, total;

  ProgramDetail({
    required this.program,
    required this.paidBy,
    required this.fee,
    required this.outstanding,
    required this.total,
  });
}

List<Map<String?, dynamic>> demoRecentFiles = [
  {
    'program': 'CII Certificate',
    'paidBy': 'EIC',
    'fee': 120000,
    'outstanding': 0.0,
    'paid': 120000,
  },
  {
    'program': 'CISI',
    'paidBy': 'EIC',
    'fee': 180000,
    'outstanding': 0.0,
    'paid': 180000,
  },
// Add more entries as needed
];
