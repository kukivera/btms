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

class Class {
  List<String> classes;

  Class(this.classes);
}

class ClassesDropdownPro extends StatefulWidget {
  const ClassesDropdownPro({super.key});

  @override
  State<ClassesDropdownPro> createState() => _ClassesDropdownProState();
}

class _ClassesDropdownProState extends State<ClassesDropdownPro> {
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
  Course? selectedCourse;
  Class? selectedClass;

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
                onChanged: (Course? course) {
                  setState(() {
                    selectedCourse = course;
                  });
                },
              ),
            if (selectedCourse != null)
              ClassesDropdownContainer(
                selectedCourse: selectedCourse,
                selectedClass: selectedClass,
                onChanged: (String? selectedClass) {
                  setState(() {
                    // Update the state with the selected class
                    // Do whatever you need to with the selected class
                  });
                },
              )
          ],
        );
      } else {
        return Row(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(

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
                kSmallVerticalSpace,
                if (selectedProgram != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: BatchDropdownContainer(
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
                    onChanged: (Course? course) {
                      setState(() {
                        selectedCourse = course;
                      });
                    },
                  ),
                if (selectedCourse != null)
                ClassesDropdownContainer(
                  selectedCourse: selectedCourse,
                  selectedClass: selectedClass,
                  onChanged: (String? selectedClass) {
                    setState(() {
                      // Update the state with the selected class
                      // Do whatever you need to with the selected class
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
  final Course? selectedCourse;
  final ValueChanged<Course?> onChanged;

  const CourseDropdownContainer({
    super.key,
    required this.selectedSection,
    required this.selectedCourse,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
      width: 150,
      child: DropdownButtonFormField<Course>(
        autofocus: true,
        focusColor: primaryColor,
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Colors.white,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        value: selectedCourse ?? selectedSection!.courses.first,
        hint: const Text(
          'Select Course',
          style: kMediumColoredBoldTextStyle,
        ),
        onChanged: onChanged,
        items: selectedSection!.courses.map((Course course) {
          return DropdownMenuItem<Course>(
            value: course,
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

class ClassesDropdownContainer extends StatelessWidget {
  final Course? selectedCourse;
  final Class? selectedClass;
  final ValueChanged<String?> onChanged;

  const ClassesDropdownContainer({
    super.key,
    required this.selectedCourse,
    required this.selectedClass,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<String> classes = [];

    if (selectedCourse != null) {
      classes = selectedCourse!.classes;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(

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
          value: selectedCourse?.classes.first,
          hint: const Text(
            'Select Class',
            style: kMediumColoredBoldTextStyle,
          ),
          onChanged: onChanged,
          items: classes.map((String classItem) {
            return DropdownMenuItem<String>(
              value: classItem,
              child: Text(
                classItem,
                style: kMediumColoredTextStyle,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
