import 'package:bruh_finance_tms/constants.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_model.dart';
import 'teachers_model.dart';
import 'package:intl/intl.dart';

class ScheduleAndAssign extends StatefulWidget {
  final String selectedProgram;
  final String selectedBatch;
  final String selectedSection;

  const ScheduleAndAssign({
    super.key,
    required this.selectedProgram,
    required this.selectedBatch,
    required this.selectedSection,
  });

  @override
  State<ScheduleAndAssign> createState() => _ScheduleAndAssignState();
}

class _ScheduleAndAssignState extends State<ScheduleAndAssign> {
  List<Course> selectedCourses = [];
  List<Course> courses = [];
  List<Course> sectionCourses = [];
  bool isLoadingSectionCourses = true;
  Course? selectedCourse;
  List<Teachers> selectedTeachers = [];
  List<String> venues = [];
  List<Map<String, dynamic>>? scheduleData;
  List<Teachers> teachers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _loadSectionCourses();
    _loadVenues();
    _fetchTeachers();
  }

  Future<void> _loadCourses() async {
    final fetchedCourses = await fetchCourses(widget.selectedProgram);
    setState(() {
      courses = fetchedCourses;
    });
  }

  Future<void> _loadVenues() async {
    final fetchedVenues = await fetchVenues();
    setState(() {
      venues = fetchedVenues.toSet().toList(); // Ensure venues are unique
    });
  }

  Future<void> _loadSectionCourses() async {
    final fetchedCourses = await fetchSectionCourses(widget.selectedSection);
    setState(() {
      sectionCourses = fetchedCourses;
      isLoadingSectionCourses = false;
    });
  }

  Future<void> _fetchTeachers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('teachers').get();

      setState(() {
        teachers =
            snapshot.docs.map((doc) => Teachers.fromDocument(doc)).toList();
        print('Number of teachers fetched: ${teachers.length}');
      });
    } catch (e) {
      // Handle error
      print('Error fetching teachers: $e');
    }
  }

  Future<List<Course>> fetchCourses(String programId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('programId', isEqualTo: programId)
        .get();

    return snapshot.docs.map((doc) => Course.fromDocument(doc)).toList();
  }

  Future<List<Course>> fetchSectionCourses(String sectionId) async {
    final sectionSnapshot = await FirebaseFirestore.instance
        .collection('sections')
        .doc(sectionId)
        .get();

    List<DocumentReference> courseRefs =
    List<DocumentReference>.from(sectionSnapshot['courses']);
    List<Course> courses = [];

    for (DocumentReference courseRef in courseRefs) {
      DocumentSnapshot courseSnapshot = await courseRef.get();
      courses.add(Course.fromDocument(courseSnapshot));
    }

    return courses;
  }

  Future<List<String>> fetchVenues() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('venues').get();
    return snapshot.docs.map((doc) => doc['venueName'] as String).toList();
  }

  // Add Courses to Section
  Future<void> addCoursesToSection(List<Course> courses) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Convert the list of Course objects to a list of DocumentReferences
    final courseRefs = courses
        .map((course) => firestore.collection('courses').doc(course.id))
        .toList();

    // Reference to the section document (replace with actual section document path)
    final sectionRef =
    firestore.collection('sections').doc(widget.selectedSection);

    // Update the section document with the course references
    await sectionRef.update({'courses': FieldValue.arrayUnion(courseRefs)});
    _loadSectionCourses();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Courses added successfully!')),
    );
  }

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<Course> tempSelectedCourses = List.from(selectedCourses);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Courses'),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: courses.map((course) {
                    return CheckboxListTile(
                      title: Text(course.courseName),
                      value: tempSelectedCourses.contains(course),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedCourses.add(course);
                          } else {
                            tempSelectedCourses.remove(course);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCourses = tempSelectedCourses;
                    });
                    if (selectedCourses.isNotEmpty) {
                      addCoursesToSection(selectedCourses).then((_) {
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to add courses: $error')),
                        );
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Courses'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _selectCourseForSchedule(Course course) async {
    setState(() {
      selectedCourse = course;
      scheduleData = null; // Clear previous schedule data
    });

    // Fetch existing schedule data for the selected course and section
    final existingSchedule = await _fetchScheduleData(course.id, widget.selectedSection);

    setState(() {
      scheduleData = existingSchedule.isNotEmpty
          ? existingSchedule
          : List.generate(course.number_of_classes, (index) {
        return {
          'classNumber': index + 1,
          'className': '',
          'date': null,
          'venue': '',
          'assignedTutors': [],
        };
      });
    });
  }

  Future<List<Map<String, dynamic>>> _fetchScheduleData(String courseId, String sectionId) async {
    final scheduleSnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('courseId', isEqualTo: courseId)
        .where('sectionId', isEqualTo: sectionId)
        .get();

    return scheduleSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'classNumber': data['classNumber'],
        'className': data['className'],
        'date': data['date'].toDate(),
        'venue': data['venue'],
        'assignedTutors': (data['assignedTutors'] as List)
            .map((ref) => (ref as DocumentReference).id)
            .toList(),
      };
    }).toList();
  }


  Future<String> _getSectionName(String sectionId) async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc(sectionId).get();
    if (doc.exists) {
      return doc.data()!['name'];  // Adjust the field name as per your database
    }
    return 'Unknown Section';  // Default value if section is not found
  }


  Future<void> _saveSchedule(String courseId, List<Map<String, dynamic>> scheduleData) async {
    String sectionName = await _getSectionName(widget.selectedSection);  // Fetch the section name

    for (var row in scheduleData) {
      for (var tutorId in row['assignedTutors']) {
        // Check for tutor conflicts
        bool conflict = await _checkTutorConflict(tutorId, row['date']);
        if (conflict) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tutor is already assigned to another class on ${DateFormat('yyyy-MM-dd').format(row['date'])} for course ${selectedCourse!.courseCode} and section $sectionName.',
              ),
            ),
          );
          return;
        }
      }
    }

    // Save schedule if no conflicts found
    final batch = FirebaseFirestore.instance.batch();
    for (var row in scheduleData) {
      // Check if the document already exists
      final existingScheduleSnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('courseId', isEqualTo: courseId)
          .where('sectionId', isEqualTo: widget.selectedSection)
          .where('classNumber', isEqualTo: row['classNumber'])
          .get();

      if (existingScheduleSnapshot.docs.isNotEmpty) {
        // Update the existing document
        final docRef = existingScheduleSnapshot.docs.first.reference;
        batch.update(docRef, {
          'className': row['className'],
          'date': row['date'],
          'venue': row['venue'],
          'assignedTutors': row['assignedTutors']
              .map((tutorId) => FirebaseFirestore.instance.collection('teachers').doc(tutorId))
              .toList(),
        });
      } else {
        // Create a new document
        final docRef = FirebaseFirestore.instance.collection('schedules').doc();
        batch.set(docRef, {
          'courseId': courseId,
          'sectionId': widget.selectedSection,
          'classNumber': row['classNumber'],
          'className': row['className'],
          'date': row['date'],
          'venue': row['venue'],
          'assignedTutors': row['assignedTutors']
              .map((tutorId) => FirebaseFirestore.instance.collection('teachers').doc(tutorId))
              .toList(),
        });
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule saved successfully!')),
    );
  }




  Future<bool> _checkTutorConflict(String tutorId, DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('assignedTutors', arrayContains: FirebaseFirestore.instance.collection('teachers').doc(tutorId))
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();

    // If any document is found, it means there is a conflict
    return snapshot.docs.isNotEmpty;
  }


  void _showTutorSelectionDialog(Map<String, dynamic> row) {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelectedTutors = List.from(row['assignedTutors']);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Tutors'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  children: teachers.map((teacher) {
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: teacher.imageUrl != null
                                ? NetworkImage(teacher.imageUrl!)
                                : null,
                            radius: 16, // Adjust size as needed
                            child: teacher.imageUrl == null
                                ? Icon(Icons.person)
                                : null,
                          ),
                          SizedBox(width: 8),
                          Text(teacher.firstName ?? '',
                              style: kMediumColoredTextStyle),
                        ],
                      ),
                      value: tempSelectedTutors.contains(teacher.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedTutors.add(teacher.id!);
                            if (tempSelectedTutors != null) {
                              setState(() {
                                row['assignedTutors'] != null;
                              });
                            }
                          } else {
                            tempSelectedTutors.remove(teacher.id!);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      row['assignedTutors'] = tempSelectedTutors;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildScheduleTable() {
    if (selectedCourse == null || scheduleData == null) {
      return const SizedBox.shrink();
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Schedule for ${selectedCourse!.courseCode}',
            style: kLargeColoredTextStyle,
          ),
          Container(
            width: 2000,
            height: 300,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                width: 800,
                height: 300,
                child: DataTable2(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  dataRowColor: MaterialStateProperty.all(secondaryColor),
                  headingRowColor: MaterialStateProperty.all(primaryColor),
                  headingRowDecoration: kMediumBoxDecoration,
                  dividerThickness: 4,
                  checkboxAlignment: Alignment.center,
                  headingTextStyle: kMediumColoredBoldTextStyle,
                  minWidth: 600,
                  columns: const [
                    DataColumn2(
                      label: Text('No.'),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Class Name'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Date'),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Venue'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Tutor'),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Update'),
                      size: ColumnSize.M,
                    ),
                  ],
                  rows: scheduleData!.map((row) {
                    int index = scheduleData!.indexOf(row);
                    if (row['assignedTutors'] == null) {
                      row['assignedTutors'] = [];
                    }
                    // Initialize row['venue'] with a default value if it's null or empty
                    if (row['venue'] == null || row['venue'].isEmpty) {
                      row['venue'] = venues.isNotEmpty ? venues.first : null;
                    }

                    return DataRow2(
                      decoration: kMediumBoxDecoration.copyWith(
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 3.0,
                          ),
                        ],
                      ),
                      cells: [
                        DataCell(Text(
                          row['classNumber'].toString(),
                          style: kMediumColoredTextStyle,
                        )),
                        DataCell(
                          TextFormField(
                            initialValue: row['className'],
                            onChanged: (value) {
                              row['className'] = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Class name is required';
                              }
                              return null;
                            },
                            style: kMediumColoredTextStyle,
                            decoration: const InputDecoration(
                              hintText: 'Class Name',
                              hintStyle: kMediumColoredTextStyle,
                            ),
                          ),
                        ),
                        DataCell(TextButton(
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                row['date'] = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            row['date'] != null
                                ? '${row['date'].day}/${row['date'].month}/${row['date'].year}'
                                : 'Select Date',
                            style: kMediumColoredTextStyle,
                          ),
                        )),
                        DataCell(
                          DropdownButtonFormField<String>(
                            icon: const SizedBox.shrink(),
                            isExpanded: true,
                            value: row['venue'], // Ensure this is correct
                            decoration: const InputDecoration(
                              hintText: 'Select Venue',
                              hintStyle: kMediumColoredTextStyle,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            items: venues.map((venue) {
                              return DropdownMenuItem<String>(
                                value: venue,
                                child: Text(venue, style: kMediumColoredTextStyle),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                row['venue'] = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Venue is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              ...row['assignedTutors'].map<Widget>((tutorId) {
                                // Find the tutor by ID
                                final tutor = teachers.firstWhere(
                                        (teacher) => teacher.id == tutorId);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(tutor.imageUrl!),
                                    radius: 16, // Adjust size as needed
                                  ),
                                );
                              }).toList(),
                              IconButton(
                                icon: const Icon(Icons.add, color: primaryColor),
                                onPressed: () {
                                  _showTutorSelectionDialog(row);
                                },
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.update, color: primaryColor),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _updateIndividualSchedule(
                                    row, selectedCourse!.id);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _updateIndividualSchedule(Map<String, dynamic> row, String courseId) async {
    for (var tutorId in row['assignedTutors']) {
      //
      String sectionName = await _getSectionName(widget.selectedSection);
      //
      // Check for tutor conflicts
      bool conflict = await _checkTutorConflict(tutorId, row['date']);
      if (conflict) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tutor is already assigned to another class on ${DateFormat('dd-MM-yyyy').format(row['date'])} for course ${selectedCourse!.courseCode} and section $sectionName.',
            ),
          ),
        );
        return;
      }
    }

    final scheduleRef = await FirebaseFirestore.instance
        .collection('schedules')
        .where('courseId', isEqualTo: courseId)
        .where('sectionId', isEqualTo: widget.selectedSection)
        .where('classNumber', isEqualTo: row['classNumber'])
        .get();

    if (scheduleRef.docs.isNotEmpty) {
      final docRef = scheduleRef.docs.first.reference;
      await docRef.update({
        'className': row['className'],
        'date': row['date'],
        'venue': row['venue'],
        'assignedTutors': row['assignedTutors']
            .map((tutorId) =>
            FirebaseFirestore.instance.collection('teachers').doc(tutorId))
            .toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class schedule updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Schedule And Assign ',
          style: kWhiteText,
        ),
      ),
      body: Column(
        children: [
          kMediumVerticalSpace,
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 20.0, 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateColor.resolveWith((states) => primaryColor),
                ),
                onPressed: _showAddCourseDialog,
                child: const Text(
                  'Add Courses',
                  style: kWhiteText,
                ),
              ),
            ),
          ),
          isLoadingSectionCourses
              ? const Center(child: CircularProgressIndicator())
              : sectionCourses.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sectionCourses
                  .map(
                    (course) =>
                    GestureDetector(
                      onTap: () =>
                          setState(() {
                            _selectCourseForSchedule(course);
                          }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: kBasicBoxDecoration.copyWith(
                              color: secondaryColor),
                          padding: const EdgeInsets.all(6),
                          child: Text(course.courseName,
                              style: kLargeColoredBoldTextStyle),
                        ),
                      ),
                    ),
              )
                  .toList(),
            ),
          )
              : const SizedBox(), // Empty SizedBox if sectionCourses is empty
          kMediumVerticalSpace,
          _buildScheduleTable(),
          if (selectedCourse != null && scheduleData != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateColor.resolveWith((states) => primaryColor)),
                onPressed: () {
                  print('Save Schedule button pressed');
                  if (selectedCourse != null &&
                      scheduleData != null &&
                      _formKey.currentState!.validate()) {
                    print('Validation passed, saving schedule');
                    _saveSchedule(selectedCourse!.id, scheduleData!)
                        .then((_) {
                      print('Schedule saved successfully');
                    })
                        .catchError((error) {
                      print('Failed to save schedule: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save schedule: $error')),
                      );
                    });
                  } else {
                    print('Validation failed or selectedCourse/scheduleData is null');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Validation failed or missing data')),
                    );
                  }
                },
                child: const Text('Save Schedule', style: kWhiteText),
              ),
            ),
        ],
      ),
    );
  }
}
