import 'package:bruh_finance_tms/constants.dart';

import 'package:bruh_finance_tms/screens/dashboard/components/header.dart';
import 'package:bruh_finance_tms/screens/payment/profilePage.dart';
import 'package:flutter/material.dart';

import '../../widgets/course_dropdown/program_dropdown.dart';

class ExamResult extends StatefulWidget {
  const ExamResult({super.key});

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  final List<Map<String, String>> dummyData = [
    {
      'studentName': 'John Doe',
      'courseName': 'Mathematics',
      'result': '80',
      'programName': 'Bachelor of Science',
      'attendancePercentage': '90%',
    },
    {
      'studentName': 'Jane Smith',
      'courseName': 'Science',
      'result': '90',
      'programName': 'Bachelor of Arts',
      'attendancePercentage': '85%',
    },
    {
      'studentName': 'Alice Johnson',
      'courseName': 'History',
      'result': '75',
      'programName': 'Bachelor of Arts',
      'attendancePercentage': '88%',
    },
    {
      'studentName': 'Bob Wilson',
      'courseName': 'English',
      'result': '85',
      'programName': 'Bachelor of Science',
      'attendancePercentage': '92%',
    },
    {
      'studentName': 'Emma Brown',
      'courseName': 'Physics',
      'result': '95',
      'programName': 'Bachelor of Science',
      'attendancePercentage': '87%',
    },
    {
      'studentName': 'Michael Taylor',
      'courseName': 'Chemistry',
      'result': '88',
      'programName': 'Bachelor of Arts',
      'attendancePercentage': '91%',
    },
    // Add more dummy data as needed
  ];

  late List<Map<String, String>> filteredData;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = dummyData;
  }

  void filterData(String query) {
    setState(() {
      filteredData = dummyData.where((data) {
        final studentName = data['studentName']!.toLowerCase();
        return studentName.contains(query.toLowerCase());
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Header(title: null,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProgramDropdown(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    style: kMediumTextStyle,
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      labelStyle: kMediumTextStyle,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: filterData,
                  ),
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: 'Sort By',
                  onChanged: (value) {
                    if (value == 'Student Name') {
                      setState(() {
                        filteredData.sort((a, b) => b['studentName']!.compareTo(a['studentName']!));
                      });
                    } else if (value == 'Result') {
                      setState(() {
                        filteredData.sort((a, b) => b['result']!.compareTo(a['result']!));
                      });
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Sort By',
                      child: Text('Sort By',style: kMediumTextStyle,),
                    ),
                    DropdownMenuItem(
                      value: 'Student Name',
                      child: Text('Student Name',style: kMediumTextStyle,),
                    ),
                    DropdownMenuItem(
                      value: 'Result',
                      child: Text('Result',style: kMediumTextStyle,),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.lightBlue),
            columns: const [
              DataColumn(
                label: Text('Student Name', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Course Name', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Result', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Program Name', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Attendance %', style: TextStyle(color: Colors.black)),
              ),
            ],
            rows: filteredData.map((data) {
              return DataRow(
                cells: [
                  DataCell(GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(
                          name: data['studentName'],
                          result: data['result'],
                        )),
                      );
                    },
                    child: Text(
                      data['studentName']!,
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
                  DataCell(Text(
                    data['courseName']!,
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    data['result']!,
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    data['programName']!,
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    data['attendancePercentage']!,
                    style: TextStyle(color: Colors.black),
                  )),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
