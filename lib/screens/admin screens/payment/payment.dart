import 'package:bruh_finance_tms/constants.dart';


import 'package:flutter/material.dart';

import '../../../widgets/course_dropdown/program_dropdown.dart';
import '../../../widgets/header.dart';

import '../result/profilePage.dart';



class Payment1 extends StatefulWidget {
  const Payment1({super.key});

  @override
  State<Payment1> createState() => _Payment1State();
}

class _Payment1State extends State<Payment1> {
  final List<Map<String, String>> dummyData = [
    {
      'StudentName': 'John Doe',
      'ProgramName': 'CII Certificate',
      'Batch': '2023',
      'Payment': 'Fully Paid',
      'PaymentStatus': 'Paid',
    },
    {
      'StudentName': 'Biryani hagos',
      'ProgramName': 'CII Diploma',
      'Batch': '2023',
      'Payment': 'Partially Paid',
      'PaymentStatus': 'Pending',
    },
    {
      'StudentName': 'Birhanu Gebisa',
      'ProgramName': 'CISI',
      'Batch': '2024',
      'Payment': 'Partially Paid',
      'PaymentStatus': 'Pending',
    },
    {
      'StudentName': 'John Doe',
      'ProgramName': 'CII Certificate',
      'Batch': '2023',
      'Payment': 'Fully Paid',
      'PaymentStatus': 'Paid',
    },
    {
      'StudentName': 'Biryani Hagos',
      'ProgramName': 'CII Diploma',
      'Batch': '2023',
      'Payment': 'Partially Paid',
      'PaymentStatus': 'Overdue',
    },
    {
      'StudentName': 'Birhanu Gebisa',
      'ProgramName': 'CISI',
      'Batch': '2024',
      'Payment': 'Partially Paid',
      'PaymentStatus': 'Pending',
    },
    // Add more dummy data as needed
  ];

  List<Map<String, String>> filteredData = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = dummyData;
  }

  void filterData(String query) {
    setState(() {
      filteredData = dummyData.where((data) {
        final studentName = data['StudentName']!.toLowerCase();
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
          const Padding(
            padding:kRegularPadding,
            child: Header(title: 'Payment',),
          ),
          const Padding(
            padding:kRegularPadding ,
            child: ProgramDropdown(),
          ),
          Padding(
            padding: kRegularPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
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
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: 'Sort By',
                  onChanged: (value) {
                    if (value == 'Student Name') {
                      setState(() {
                        filteredData.sort((a, b) =>
                            a['StudentName']!.compareTo(b['StudentName']!));
                      });
                    } else if (value == 'Payment') {
                      setState(() {
                        filteredData.sort(
                                (a, b) => a['Payment']!.compareTo(b['Payment']!));
                      });
                    } else if (value == 'Payment Status') {
                      setState(() {
                        filteredData.sort((a, b) => a['PaymentStatus']!
                            .compareTo(b['PaymentStatus']!));
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Sort By',
                      child: Text(
                        'Sort By',
                        style: kMediumTextStyle,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Student Name',
                      child: Text(
                        'Student Name',
                        style: kMediumTextStyle,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Payment',
                      child: Text(
                        'Payment',
                        style: kMediumTextStyle,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Payment Status',
                      child: Text(
                        'Payment Status',
                        style: kMediumTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DataTable(
            headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.lightBlue),
            columns: const [
              DataColumn(
                label: Text('Student Name', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Program Name', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Batch', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Payment', style: TextStyle(color: Colors.black)),
              ),
              DataColumn(
                label: Text('Payment Status', style: TextStyle(color: Colors.black)),
              ),
            ],
            rows: filteredData.map((data) {
              Color statusColor;
              switch (data['PaymentStatus']) {
                case 'Fully Paid':
                  statusColor = Colors.lightBlueAccent;
                  break;
                case 'Pending':
                  statusColor = Colors.yellow;
                  break;
                case 'Overdue':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.white;
              }
              return DataRow(
                color: MaterialStateColor.resolveWith((states) => statusColor),
                cells: [
                  DataCell(GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              name: data['StudentName'],
                              result: data['Payment'],
                            )),
                      );
                    },
                    child: Text(
                      data['StudentName']!,
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
                  DataCell(Text(
                    data['ProgramName']!,
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    data['Batch']!,
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    data['Payment']!,
                    style: TextStyle(color: Colors.black),
                  )),
                  DataCell(Text(
                    data['PaymentStatus']!,
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
