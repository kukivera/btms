

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';


class AssignStudent extends StatefulWidget {
  const AssignStudent({
    super.key,
    required this.selectedProgram,
    required this.selectedBatch,
    required this.selectedSection,
  });

  final String selectedProgram;
  final String selectedBatch;
  final String selectedSection;

  @override
  State<AssignStudent> createState() => _AssignStudentState();
}

class _AssignStudentState extends State<AssignStudent> {
  List<Students> students = [];
  List<Students> studentsForLIst = [];
  List<Students> filteredStudents = [];
  List<Students> filteredListStudents = [];
  Set<String> selectedStudentIds = {};
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
    _fetchStudentsForList();
  }

  Future<void> _fetchStudents() async {
    try {
      // Fetch all students
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .get();

      String excludedSectionId = widget.selectedSection;

      setState(() {
        students = snapshot.docs.map((doc) {
          var student = Students.fromFirestore(doc);
          // Debugging each student's sections
          print('Student ID: ${student.id}');
          if (student.sections != null) {
            student.sections!.forEach((ref) {
              print('Section Reference: ${ref.path}');
            });
          } else {
            print('No sections for student ID: ${student.id}');
          }
          return student;
        }).toList();

        // Filter out students with the specified section ID
        filteredStudents = students.where((student) {
          return student.sections == null ||
              !student.sections!.any((section) => section.id == excludedSectionId);
        }).toList();
           _fetchStudents();
           _fetchStudentsForList();
        print('Filtered Students: $filteredStudents');
      });
    } catch (e) {
      print('Error fetching students: $e');
      // Handle error accordingly, e.g., show a message to the user
    }
  }



  Future<void> _fetchStudentsForList() async {
    try {
      String selectedSectionId = widget.selectedSection;

      // Debugging selectedSectionId
      print('Selected Section ID: $selectedSectionId');

      // Fetch students where sections array contains the selected section ID
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .get();

      List<Students> fetchedStudents = snapshot.docs
          .map((doc) => Students.fromFirestore(doc))
          .where((student) => student.sections != null &&
          student.sections!.any((section) =>
          section.id == selectedSectionId))
          .toList();

      // Debugging fetched students
      fetchedStudents.forEach((student) {
        print('Filtered Student ID: ${student.id}');
        student.sections?.forEach((section) {
          print('Section Reference: ${section.path}');
        });
      });

      setState(() {
        studentsForLIst = fetchedStudents;
        filteredListStudents = studentsForLIst;
      });

      // Debugging the final students list
      print('Filtered Students: $filteredListStudents');
    } catch (e) {
      print('Error fetching students: $e');
      // Handle error accordingly, e.g., show a message to the user
    }
  }




  void _filterStudents(String query) {
    setState(() {
      searchQuery = query;
      filteredStudents = students.where((student) {
        final nameLower = student.firstName?.toLowerCase() ?? '';
        final lastNameLower = student.lastName?.toLowerCase() ?? '';
        final phoneLower = student.phoneNumber?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower) ||
            lastNameLower.contains(searchLower) ||
            phoneLower.contains(searchLower);
      }).toList();
    });
  }

  void _filterStudentsForList(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      print('Search query: $searchQuery'); // Debugging info

      filteredListStudents = studentsForLIst.where((student) {
        final nameLower = student.firstName?.toLowerCase() ?? '';
        final lastNameLower = student.lastName?.toLowerCase() ?? '';

        bool matches = nameLower.contains(searchQuery) || lastNameLower.contains(searchQuery);
        print('Student: ${student.firstName} ${student.lastName}, Matches: $matches'); // Debugging info

        return matches;
      }).toList();

      print('Filtered List: ${filteredListStudents.length} students'); // Debugging info
    });
  }


  Future<void> _saveSelectedStudents() async {
    DocumentReference sectionRef = FirebaseFirestore.instance
        .collection('sections')
        .doc(widget.selectedSection);
    WriteBatch batch = FirebaseFirestore.instance.batch();

    List<DocumentReference> studentRefs = selectedStudentIds
        .map((id) => FirebaseFirestore.instance.collection('students').doc(id))
        .toList();

    // Update the section with the selected students
    batch.update(sectionRef, {'students': FieldValue.arrayUnion(studentRefs)});

    // Update each selected student with the section reference in the sections array
    for (var studentId in selectedStudentIds) {
      DocumentReference studentRef =
      FirebaseFirestore.instance.collection('students').doc(studentId);
      batch.update(studentRef, {
        'sections': FieldValue.arrayUnion([sectionRef])
      });
    }

    await batch.commit();
    _fetchStudents();
    _fetchStudentsForList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Students assigned successfully!')),
    );
  }

  Future<void> _removeStudentFromSection(String studentId) async {
    DocumentReference sectionRef = FirebaseFirestore.instance
        .collection('sections')
        .doc(widget.selectedSection);

    DocumentReference studentRef = FirebaseFirestore.instance
        .collection('students')
        .doc(studentId);

    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Update the section's students array to remove the student reference
    batch.update(sectionRef, {
      'students': FieldValue.arrayRemove([studentRef])
    });

    // Remove the section reference from the student's sections array
    batch.update(studentRef, {
      'sections': FieldValue.arrayRemove([sectionRef])
    });

    await batch.commit();
    _fetchStudents();
    _fetchStudentsForList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student removed from section successfully!')),
    );
  }



  Future<void> _confirmAndRemoveStudent(String studentId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to remove this student from the section?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _removeStudentFromSection(studentId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student removed successfully!')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Assign Students', style: kWhiteText),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                style: kMediumColoredTextStyle,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: secondaryColor,
                                  hintText: 'Search by name or phone',
                                  hintStyle: kMediumColoredTextStyle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
                                    borderSide: const BorderSide(
                                      color: primaryColor, // Border color when the text field is not focused
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
                                    borderSide: const BorderSide(
                                      color: primaryColor, // Border color when the text field is enabled (not focused)
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
                                    borderSide: const BorderSide(
                                      color: primaryColor, // Border color when the text field is focused
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.search, color: primaryColor),
                                ),
                                onChanged: _filterStudents,
                              ),
                            ),
                          ),
                          kMediumHorizontalSpace,
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor)),
                            onPressed: _saveSelectedStudents,
                            child: const Text('Save', style: kWhiteText),
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor, // Outer border color
                            width: 2.0, // Outer border width
                          ),
                          borderRadius: BorderRadius.circular(12.0), // Border radius
                        ),
                        child: DataTable(

                          columnSpacing: 70,
                          dividerThickness: 0.1,
                          decoration: kMediumBoxDecoration,
                          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          columns: const [
                            DataColumn(label: Text('First Name', style: kMediumColoredTextStyle)),
                            DataColumn(label: Text('Second Name', style: kMediumColoredTextStyle)),
                            DataColumn(label: Text('Phone', style: kMediumColoredTextStyle)),
                            DataColumn(label: Text('Add', style: kMediumColoredTextStyle)),
                          ],
                          rows: filteredStudents.map((student) {
                            return DataRow(

                              cells: [
                                DataCell(Text(student.firstName ?? '', style: kMediumColoredTextStyle)),
                                DataCell(Text(student.lastName ?? '', style: kMediumColoredTextStyle)),
                                DataCell(Text(student.phoneNumber ?? '', style: kMediumColoredTextStyle)),
                                DataCell(
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      checkboxTheme: CheckboxThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        side: MaterialStateBorderSide.resolveWith(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.selected)) {
                                              return const BorderSide(color: Colors.blue, width: 2);
                                            }
                                            return const BorderSide(color: Colors.blue, width: 2);
                                          },
                                        ),
                                      ),
                                    ),
                                    child: Checkbox(
                                      checkColor: primaryColor,
                                      hoverColor: primaryColor,
                                      activeColor: Colors.blue,
                                      value: selectedStudentIds.contains(student.id),
                                      onChanged: (bool? value) {
                                        if (value != null && student.id != null) {
                                          setState(() {
                                            if (value) {
                                              selectedStudentIds.add(student.id!);
                                            } else {
                                              selectedStudentIds.remove(student.id!);
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  // Divider
                  if (Responsive.isDesktop(context))
                    const VerticalDivider(
                    thickness: 4,
                    color: Colors.grey,
                    width: 20,
                  ),
                  kLargeHorizontalSpace,



                  // Expanded Column
                  if (Responsive.isDesktop(context))    Expanded(
                    child: Column(
                      children: [
                        kMediumVerticalSpace,
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Number Of Students',style: kLargeColoredBoldTextStyle,),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: kMediumBoxDecoration.copyWith(color: primaryColor),
                            width: 150,
                            height: 200,

                            child: Center(child: Text('${filteredListStudents.length} students', style: kWhiteText)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kLargeHorizontalSpace,
                  Column(
                    children: [

                         SearchByNameAndPhone(filter: _filterStudentsForList),

                      Container(

                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor, // Outer border color
                            width: 2.0, // Outer border width
                          ),
                          borderRadius: BorderRadius.circular(12.0), // Border radius
                        ),
                        child: DataTable(
                          decoration: kMediumBoxDecoration,
                          columnSpacing: 70,
                          dividerThickness: 0.1,
                          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          columns: const [
                            DataColumn(label: Text('No.', style: kMediumColoredTextStyle)),
                            DataColumn(label: Text('First Name', style: kMediumColoredTextStyle)),
                            DataColumn(label: Text('Last Name', style: kMediumColoredTextStyle)),
                            DataColumn(label: Text('Actions', style: kMediumColoredTextStyle)),
                          ],
                          rows: List.generate(filteredListStudents.length, (index) {
                            final student = filteredListStudents[index];
                            final studentIndex = index + 1;

                            return DataRow(


                              cells: [
                                DataCell(Text('$studentIndex', style: kMediumColoredTextStyle)),
                                DataCell(Text(student.firstName ?? '', style: kMediumColoredTextStyle)),
                                DataCell(Text(student.lastName ?? '', style: kMediumColoredTextStyle)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmAndRemoveStudent(student.id!),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Students {
  final String? dob,
      email,
      firstName,
      lastName,
      name,
      phoneNumber,
      program,
      role,
      profilePic,
      companyName,
      instalment,
      position,
      secondaryphone,
      batch,
      sponsor,
      id;
  final List<DocumentReference>? sections;

  Students({
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.name,
    this.phoneNumber,
    this.program,
    this.role,
    this.profilePic,
    this.companyName,
    this.instalment,
    this.position,
    this.secondaryphone,
    this.batch,
    this.sections,
    this.sponsor,
    required this.id,
  });

  // Convert Student object to a Map
  Map<String, dynamic> toMap() {
    return {
      'dob': dob,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'phoneNumber': phoneNumber,
      'program': program,
      'role': role,
      'profilePic': profilePic,
      'companyName': companyName,
      'instalment': instalment,
      'position': position,
      'secondaryphone': secondaryphone,
      'batch': batch,
      'sections': sections?.map((ref) => ref.path).toList(),
      'sponsor': sponsor,
      'id': id,
    };
  }

  factory Students.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Students(
      dob: data['dob'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      program: data['program'],
      role: data['role'],
      profilePic: data['profilePic'],
      companyName: data['companyName'],
      instalment: data['instalment'],
      position: data['position'],
      secondaryphone: data['secondaryphone'],
      batch: data['batch'],
      sections: (data['sections'] as List<dynamic>?)
          ?.map((section) => section as DocumentReference)
          .toList(),
      sponsor: data['sponsor'],
      id: doc.id,
    );
  }

}

class SearchByNameAndPhone extends StatelessWidget {
  final void Function(String query) filter;

  const SearchByNameAndPhone({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          style: kMediumColoredTextStyle,
          decoration: InputDecoration(
            filled: true,
            fillColor: secondaryColor,
            hintText: 'Search by name',
            hintStyle: kMediumColoredTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
              borderSide: const BorderSide(
                color: primaryColor, // Border color when the text field is not focused
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
              borderSide: const BorderSide(
                color: primaryColor, // Border color when the text field is enabled (not focused)
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
              borderSide: const BorderSide(
                color: primaryColor, // Border color when the text field is focused
                width: 2.0,
              ),
            ),
            suffixIcon: const Icon(Icons.search, color: primaryColor),
          ),
          onChanged: filter,
        ),
      ),
    );
  }
}
