import 'package:bruh_finance_tms/constants.dart';
import 'package:bruh_finance_tms/widgets/programSelection/program_selection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../widgets/course_button_row.dart';
import '../../../widgets/header.dart';

class NewSchedule extends StatefulWidget {
  const NewSchedule({super.key});

  @override
  State<NewSchedule> createState() => _NewScheduleState();
}

class _NewScheduleState extends State<NewSchedule> {


  String activeProgram = 'CII Certificate';

  void setActiveProgram(String program) {
    setState(() {
      activeProgram = program;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 10, 16, 10),
            child: Header(
              title: 'Schedule',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProgramSelectorRow(
                activeProgram: 'CII Certificate',
                program1: 'CISI',
                program2: 'CII Diploma',
                setActiveProgram: setActiveProgram,
                program2Color: Colors.green,
                program1Color: Colors.orange),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CourseButtonRow(
              courseLabels: const [
                'W01',
                'WCE',
                'WUE',
              ], // Example list of course labels
              onPressed: [
                () {
                  // onPressed for W01
                  print('W01 pressed');
                },
                () {
                  // onPressed for WCE
                  print('WCE pressed');
                },
                () {
                  // onPressed for WUE
                  print('WUE pressed');
                },
              ],
            ),
          ),
          const SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScheduleTable(),
                kMediumHorizontalSpace,
                ScheduleTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ScheduleTable extends StatelessWidget {
  const ScheduleTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kLargeVerticalSpace,
        const SizedBox(
          height: 25,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Venue: ${classInfo.venue}"),
                                    const Text("Location: Addis Ababa Bole"),
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

