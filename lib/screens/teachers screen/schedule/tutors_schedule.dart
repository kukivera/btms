import 'package:bruh_finance_tms/widgets/calender_widget.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';


import '../../../constants.dart';


import '../../../widgets/drop downs/courseSelectionDropDown.dart';
import '../../../widgets/header.dart';


class TutorsSchedule extends StatefulWidget {
  const TutorsSchedule({super.key});

  @override
  TutorsScheduleState createState() => TutorsScheduleState();
}

class TutorsScheduleState extends State<TutorsSchedule> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(
          title: 'Schedule',
        ),
        const CourseSelectionDropdown(),

        Row(
          children: [
            Container(
              width: 500,
              height: 400,
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: Calendar(


              )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kLargeVerticalSpace,
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                  child: Text(
                    'Schedule Detail',
                    style: kLargeColoredBoldTextStyle,
                  ),
                ),
                kMediumVerticalSpace,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    width: 500,
                    child: DataTable2(
                      dataRowColor: MaterialStateProperty.all(secondaryColor),
                      headingRowColor: MaterialStateProperty.all(primaryColor),
                      headingRowDecoration: kMediumBoxDecoration,
                      dividerThickness: 4,
                      headingTextStyle: kMediumColoredBoldTextStyle,
                      columns: const [
                        DataColumn2(
                          label: Text(
                            'Class',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        DataColumn2(
                          label: Text(
                            'Date',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        DataColumn2(
                          label: Text(
                            'Venue',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      rows: dummyData.map((classInfo) {
                        return DataRow2.byIndex(
                          index: dummyData.indexOf(classInfo),
                          decoration: kMediumWhiteBoxDecoration.copyWith(
                            boxShadow: [
                              const BoxShadow(
                                color: secondaryColor,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 3.0,
                                spreadRadius: 3.0,
                              ),
                            ],
                          ),
                          cells: [
                            DataCell(
                              Text(
                                classInfo.className,
                                style: kMediumColoredBoldTextStyle,
                              ),
                            ),
                            DataCell(
                              Text(
                                classInfo.date,
                                style: kMediumColoredBoldTextStyle,
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: primaryColor,
                                        title: const Text("Venue Location"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Venue: ${classInfo.venue}"),
                                            const Text(
                                                "Location: Addis Ababa Bole"),
                                            const Text("Floor: 2nd Floor"),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  classInfo.venue,
                                  style: kMediumColoredBoldTextStyle,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}


class ClassInfo {
  final String className;
  final String date;
  final String venue;

  ClassInfo({required this.className, required this.date, required this.venue});
}

final List<ClassInfo> dummyData = [
  ClassInfo(className: '1', date: '2024-04-18', venue: 'The Hub Hotel'),
  ClassInfo(className: '2', date: '2024-04-20', venue: 'The Hub Hotel'),
  ClassInfo(className: '3', date: '2024-04-22', venue: 'The Hub Hotel'),
  ClassInfo(className: '4', date: '2024-04-24', venue: 'The Hub Hotel'),
];
