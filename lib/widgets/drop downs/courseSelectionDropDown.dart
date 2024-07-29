import 'package:flutter/material.dart';

import '../../constants.dart';

class Programs {
  final String name;
  final List<Batch> batches;
  final Color color;

  Programs(this.name, this.batches, this.color);
}

class Batch {
  final int year;
  final List<String> courses;

  Batch(this.year, this.courses);
}

class CourseSelectionDropdown extends StatefulWidget {
  const CourseSelectionDropdown({super.key});

  @override
  State<CourseSelectionDropdown> createState() =>
      _CourseSelectionDropdownState();
}

class _CourseSelectionDropdownState extends State<CourseSelectionDropdown> {
  List<Programs> programs = [
    Programs(
        'CII',
        [
          Batch(2024, ['WO1', 'WCE', 'WUE']),
          Batch(2025, ['WO1', 'WCE', 'WUE'])
        ],
        primaryColor),
    Programs(
        'CII D',
        [
          Batch(2024, ['Course X', 'Course Y']),
          Batch(2025, ['Course A', 'Course B'])
        ],
        Colors.orange),
    Programs(
        'CISI',
        [
          Batch(2024, ['Course Alpha']),
          Batch(2025, ['Course Beta'])
        ],
        Colors.green),
  ];

  List<String> selectedCourses = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var program in programs)
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 9),
                    buildBatchDropdown(program),
                    const SizedBox(height: 9),
                  ],
                ),
              ),
          ],
        ),
        Row(
          children: selectedCourses
              .map(
                (course) => Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(secondaryColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(
                        course,
                        style: const TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildBatchDropdown(Programs program) {
    return Container(
      width: 100,
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      decoration: kMediumBoxDecoration.copyWith(
        color: secondaryColor,
      ),
      child: DropdownButtonFormField<Batch>(
        hint: Text(
          program.name,
          style: kMediumColoredTextStyle.copyWith(color: primaryColor),
        ),
        icon: Icon(
          Icons.circle,
          color: program.color,
        ),
        value: null,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        dropdownColor: Colors.white,
        onChanged: (batch) {
          setState(() {
            selectedCourses = batch!.courses;
          });
        },
        items: program.batches.map((batch) {
          return DropdownMenuItem<Batch>(
            value: batch,
            child: Text(
              batch.year.toString(),
              style: kSmallColorTextStyle.copyWith(color: primaryColor),
            ),
          );
        }).toList(),
      ),
    );
  }
}
