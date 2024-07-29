import 'package:bruh_finance_tms/responsive.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Program {
  String name;
  List<Batch> batches;
  Color color;

  Program(this.name, this.batches, this.color);
}

class Batch {
  int year;
  List<Section> sections;

  Batch(this.year, this.sections);
}

class Section {
  String name;
  List<Course> courses;

  Section(this.name, this.courses);
}

class Course {
  String name;
  List<String> classes;

  Course(this.name, this.classes);
}

class ProgramDropdownPro extends StatefulWidget {
  const ProgramDropdownPro({super.key});

  @override
  State<ProgramDropdownPro> createState() => _ProgramDropdownProState();
}

class _ProgramDropdownProState extends State<ProgramDropdownPro> {
  final List<Program> programs = [
    Program(
      'CII',
      [
        Batch(
          2023,
          [
            Section(
              'Section 1',
              [
                Course('W01', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
                Course('UCE', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
            Section(
              'Section 2',
              [
                Course('CUE', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
            Section(
              'Section 3',
              [
                Course('', []),
              ],
            ),
          ],
        ),
        Batch(
          2024,
          [
            Section(
              'Section 1',
              [
                Course(
                    'Course 1', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
                Course(
                    'Course 2', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
            Section(
              'Section 2',
              [
                Course(
                    'Course 3', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
                Course(
                    'Course 4', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
          ],
        ),
      ],
      Colors.blue,
    ),
    Program(
      'CII D',
      [
        Batch(
          2023,
          [
            Section(
              'Section 1',
              [
                Course(
                    'Course X', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
            Section(
              'Section 2',
              [
                Course(
                    'Course Y', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
          ],
        ),
        Batch(
          2024,
          [
            Section(
              'Section 1',
              [
                Course(
                    'Course A', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
            Section(
              'Section 2',
              [
                Course(
                    'Course B', ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
          ],
        ),
      ],
      Colors.orange,
    ),
    Program(
      'CISI',
      [
        Batch(
          2023,
          [
            Section(
              'Section 1',
              [
                Course('Course Alpha',
                    ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
          ],
        ),
        Batch(
          2024,
          [
            Section(
              'Section 1',
              [
                Course('Course Beta',
                    ['Class 1', 'Class 2', 'Class 3', 'Class 4']),
              ],
            ),
          ],
        ),
      ],
      Colors.green,
    ),
  ];
  Program? selectedProgram;
  Batch? selectedBatch;
  Section? selectedSection;
  String? selectedCourse;
  String? selectedClass;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 600) {
        // Desktop layout
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProgramDropdownContainer(
              programs: programs,
              selectedProgram: selectedProgram,
              onChanged: (Program? program) {
                setState(() {
                  selectedProgram = program;
                  selectedBatch = null;
                  selectedSection = null;
                  selectedCourse = null;
                });
              },
            ),
            kMediumHorizontalSpace,
            if (selectedProgram != null)
              BatchDropdownContainer(
                selectedProgram: selectedProgram,
                selectedBatch: selectedBatch,
                onChanged: (Batch? batch) {
                  setState(() {
                    selectedBatch = batch;
                    selectedSection = null;
                    selectedCourse = null;
                    selectedClass = null;
                  });
                },
              ),
            kMediumHorizontalSpace,
            if (selectedBatch != null)
              SectionDropdownContainer(
                selectedBatch: selectedBatch,
                selectedSection: selectedSection,
                onChanged: (Section? section) {
                  setState(() {
                    selectedSection = section;
                    selectedCourse = null;
                    selectedClass = null;
                  });
                },
              ),
            kMediumHorizontalSpace,
            if (selectedSection != null)
              CourseDropdownContainer(
                selectedSection: selectedSection,
                selectedCourse: selectedCourse,
                onChanged: (String? course) {
                  setState(() {
                    selectedCourse = course;
                    selectedClass = null;
                  });
                },
              ),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ProgramDropdownContainer(
                  programs: programs,
                  selectedProgram: selectedProgram,
                  onChanged: (Program? program) {
                    setState(() {
                      selectedProgram = program;
                      selectedBatch = null;
                      selectedSection = null;
                      selectedCourse = null;
                    });
                  },
                ),
                kSmallVerticalSpace,
                if (selectedProgram != null)
                  BatchDropdownContainer(
                    selectedProgram: selectedProgram,
                    selectedBatch: selectedBatch,
                    onChanged: (Batch? batch) {
                      setState(() {
                        selectedBatch = batch;
                        selectedSection = null;
                        selectedCourse = null;
                      });
                    },
                  ),
              ],
            ),
            kMediumHorizontalSpace,
            Column(
              children: [
                if (selectedBatch != null)
                  SectionDropdownContainer(
                    selectedBatch: selectedBatch,
                    selectedSection: selectedSection,
                    onChanged: (Section? section) {
                      setState(() {
                        selectedSection = section;
                        selectedCourse = null;
                      });
                    },
                  ),
                kSmallVerticalSpace,
                if (selectedSection != null)
                  CourseDropdownContainer(
                    selectedSection: selectedSection,
                    selectedCourse: selectedCourse,
                    onChanged: (String? course) {
                      setState(() {
                        selectedCourse = course;
                      });
                    },
                  )
              ],
            )
          ],
        );
      }
    });
  }
}

// program dropdown

class ProgramDropdownContainer extends StatelessWidget {
  final List<Program> programs;
  final Program? selectedProgram;
  final ValueChanged<Program?> onChanged;

  const ProgramDropdownContainer({
    Key? key,
    required this.programs,
    required this.selectedProgram,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        decoration: kBasicBoxDecoration.copyWith(
          color: secondaryColor,
        ),
        width: 150,
        child: DropdownButtonFormField<Program>(
          autofocus: true,
          icon: Icon(
            Icons.circle,
            color: selectedProgram?.color ?? selectedProgram?.color,
          ),
          focusColor: primaryColor,
          borderRadius: BorderRadius.circular(20),
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          value: selectedProgram ?? programs.first,
          onChanged: onChanged,
          items: programs.map((Program program) {
            return DropdownMenuItem<Program>(
              value: program,
              child: Text(
                program.name,
                style: kMediumColoredTextStyle,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

//batch dropdown

class BatchDropdownContainer extends StatelessWidget {
  final Program? selectedProgram;
  final Batch? selectedBatch;
  final ValueChanged<Batch?> onChanged;

  const BatchDropdownContainer({
    Key? key,
    required this.selectedProgram,
    required this.selectedBatch,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
      width: 150,
      child: DropdownButtonFormField<Batch>(
        autofocus: true,
        dropdownColor: Colors.white,
        focusColor: primaryColor,
        borderRadius: BorderRadius.circular(20),
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        value: selectedBatch ?? selectedProgram!.batches.first,
        hint: const Text(
          'Select Batch',
          style: kMediumColoredBoldTextStyle,
        ),
        onChanged: onChanged,
        items: selectedProgram!.batches.map((Batch batch) {
          return DropdownMenuItem<Batch>(
            value: batch,
            child: Text(
              'Batch ${batch.year}',
              style: kMediumColoredTextStyle,
            ),
          );
        }).toList(),
      ),
    );
  }
}

//section dropdown

class SectionDropdownContainer extends StatelessWidget {
  final Batch? selectedBatch;
  final Section? selectedSection;
  final ValueChanged<Section?> onChanged;

  const SectionDropdownContainer({
    Key? key,
    required this.selectedBatch,
    required this.selectedSection,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
      width: 150,
      child: DropdownButtonFormField<Section>(
        autofocus: true,
        focusColor: primaryColor,
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Colors.white,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        value: selectedSection ?? selectedBatch!.sections.first,
        hint: const Text(
          'Select Section',
          style: kMediumColoredBoldTextStyle,
        ),
        onChanged: onChanged,
        items: selectedBatch!.sections.map((Section section) {
          return DropdownMenuItem<Section>(
            value: section,
            child: Text(
              section.name,
              style: kMediumColoredTextStyle,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Course dropdown

class CourseDropdownContainer extends StatelessWidget {
  final Section? selectedSection;
  final String? selectedCourse;
  final ValueChanged<String?> onChanged;

  const CourseDropdownContainer({
    Key? key,
    required this.selectedSection,
    required this.selectedCourse,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
      width: 150,
      child: DropdownButtonFormField<String>(
        autofocus: true,
        focusColor: primaryColor,
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Colors.white,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        value: selectedCourse ?? selectedSection!.courses.first.name,
        hint: const Text(
          'Select Course',
          style: kMediumColoredBoldTextStyle,
        ),
        onChanged: onChanged,
        items: selectedSection!.courses.map((Course course) {
          return DropdownMenuItem<String>(
            value: course.name,
            child: Text(
              course.name,
              style: kMediumColoredTextStyle,
            ),
          );
        }).toList(),
      ),
    );
  }
}

