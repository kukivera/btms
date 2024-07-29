import 'package:bruh_finance_tms/constants.dart';

import 'package:bruh_finance_tms/widgets/ProgramCard/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../header.dart';

class ProgCard extends StatefulWidget {
  const ProgCard({Key? key}) : super(key: key);

  @override
  State<ProgCard> createState() => _ProgCardState();
}

class _ProgCardState extends State<ProgCard> {
  final List<Map<String, dynamic>> dummyData = [
    {
      'title': 'CII Certificate',
      'description': 'beginners level Certificate',
      'batches': ['Batch 1', 'Batch 2', 'Batch 3'],
    },
    {
      'title': 'CII Diploma',
      'description': 'middle management level qualification',
      'batches': ['Batch 1', 'Batch 2', 'Batch 3'],
    },
    {
      'title': 'CISI',
      'description': 'middle management level qualification',
      'batches': ['Batch 1', 'Batch 2', 'Batch 3'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: 'Programs',),
        kMediumVerticalSpace,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: (1 / .4),
          children: List.generate(dummyData.length, (index) {
            final cardData = dummyData[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgramProfile(
                      title: cardData['title']!,
                    ),
                  ),
                );
              },
              child: MyCard(
                title: cardData['title']!,
                description: cardData['description']!,
              ),
            );
          }),
        ),
      ],
    );
  }
}



class ProgramProfile extends StatefulWidget {
  final String title;

  const ProgramProfile({Key? key, required this.title}) : super(key: key);

  @override
  _ProgramProfileState createState() => _ProgramProfileState();
}

class _ProgramProfileState extends State<ProgramProfile> {
  String? selectedYear;


  String? selectedBatch;
  String? selectedSection;
  String? selectedStudent;

  List<String> batches = ['2023', '2024'];
  Map<String, List<String>> sections = {
    '2023': ['Section A', 'Section B'],
    '2024': ['Section C', 'Section D'],
  };
  Map<String, List<String>> students = {
    'Section A': ['John', 'Alice'],
    'Section B': ['Bob', 'Emma'],
    'Section C': ['Charlie', 'Ella'],
    'Section D': ['David', 'Fiona'],
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: Text('Select Batch',style: kSmallTextStyle,),
              value: selectedBatch,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBatch = newValue;
                  selectedSection = null;
                  selectedStudent = null;
                });
              },
              items: batches.map((batch) {
                return DropdownMenuItem<String>(
                  value: batch,
                  child: Text(batch,style: kSmallTextStyle,),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (selectedBatch != null)
              DropdownButton<String>(
                hint: Text('Select Section',style: kSmallTextStyle,),
                value: selectedSection,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSection = newValue;
                    selectedStudent = null;
                  });
                },
                items: sections[selectedBatch!]!.map((section) {
                  return DropdownMenuItem<String>(
                    value: section,
                    child: Text(section),
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            if (selectedSection != null)
              DropdownButton<String>(
                hint: Text('Select Student',style: kSmallTextStyle,),
                value: selectedStudent,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStudent = newValue;
                  });
                },
                items: students[selectedSection!]!.map((student) {
                  return DropdownMenuItem<String>(
                    value: student,
                    child: Text(student),
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            if (selectedSection != null)
              ElevatedButton(
                onPressed: () {
                  // Add new section logic
                },
                child: Text('Add Section'),
              ),
          ],
        ),
      ),
    );
  }
}