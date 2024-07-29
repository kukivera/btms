import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants.dart';
import '../../../widgets/header.dart';
import '../../../widgets/programSelection/program_selection.dart';


class NewExamBooking extends StatefulWidget {
  const NewExamBooking({super.key});

  @override
  State<NewExamBooking> createState() => _NewExamBookingState();
}

class _NewExamBookingState extends State<NewExamBooking> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  List<DateTime> _highlightedDates = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];
  String activeProgram = 'CII Certificate';

  void setActiveProgram(String program) {
    setState(() {
      activeProgram = program;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0,10,16,10),
            child: Header(title: 'Exam Booking',),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProgramSelectorRow(activeProgram: 'CII Certificate', program1: 'CISI', program2: 'CII Diploma', setActiveProgram: setActiveProgram, program2Color: Colors.green, program1Color: Colors.orange),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){}, child: Text('W01',style: kMediumTextStyle.copyWith(color: Colors.white),),style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Colors.lightBlueAccent),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(10.0),


                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){}, child: Text('WCE',style: kMediumTextStyle.copyWith(color: Colors.white),),style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Colors.lightBlueAccent),

                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){}, child: Text('WUE',style: kMediumTextStyle.copyWith(color: Colors.white),),style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Colors.lightBlueAccent),

                  ),),
                ),

              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    height: 400,
                    width: 500,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        TableCalendar(
                          calendarFormat: _calendarFormat,
                          focusedDay: _selectedDay,
                          firstDay: DateTime.utc(2010, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onPageChanged: (focusedDay) {
                            _selectedDay = focusedDay;
                          },
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleTextStyle: kMediumColoredBoldTextStyle,
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, _) {
                              final isHighlighted = _highlightedDates.contains(day);
                              return Container(
                                margin: EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                  isHighlighted ? Colors.red : Colors.transparent,
                                ),
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color:
                                    isHighlighted ? Colors.white : Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Center(child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primaryColor),
                          ),
                          child: Text('book',style: TextStyle(
                            color: Colors.white,
                          ),),
                          onPressed: (){},
                        )),
                      ]),
                    ),
                  ),
                ),
                kMediumHorizontalSpace,
                Column(
                  children: [

                    ScheduleTable(),

                  ],
                ),

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
        const Text(
          'Result Detail',
          style: kLargeColoredBoldTextStyle,
        ),
        kMediumVerticalSpace,
        SizedBox(
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
                  'Date',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
              DataColumn2(
                label: Text(
                  'Result',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
              DataColumn2(
                label: Text(
                  'Update',
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
                      offset: Offset(
                        0.0,
                        0.0,
                      ), //Offset
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                    ), //BoxShadow
                  ],
                ),
                cells: [

                  DataCell(
                    Text(
                      classInfo.date,
                      style: kMediumColoredBoldTextStyle,
                    ),
                  ),
                  DataCell(
                    Text(
                      classInfo.venue,
                      style: kMediumColoredBoldTextStyle,
                    ),
                  ),
                  DataCell(
                    Icon(Icons.upload,color: primaryColor,)
                  ),
                ],
              );
            }).toList(),
          ),

        ),

      ],
    );
  }
}

class ClassInfo {

  final String date;
  final String venue;

  ClassInfo({ required this.date, required this.venue});
}

final List<ClassInfo> dummyData = [
  ClassInfo( date: '2024-04-18', venue: '80%'),
  ClassInfo( date: '2024-04-20', venue: '78%'),
  ClassInfo( date: '2024-04-22', venue: '71'),
  ClassInfo( date: 'Status', venue: 'pass'),
];
