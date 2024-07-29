
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:bruh_finance_tms/constants.dart';
import '../teacher data model/teachers_model.dart';
import '../teacher profile/teacher_profile.dart';
import '../teacher registartion/teachers_registration_services.dart';
import 'edit_teacher.dart';

class TeacherTable extends StatefulWidget {
  final List<TeacherDetail>? filteredTeachers;
  final Function onDelete;

  const TeacherTable({Key? key, this.filteredTeachers, required this.onDelete}) : super(key: key);

  @override
  State<TeacherTable> createState() => _TeacherTableState();
}

class _TeacherTableState extends State<TeacherTable> {
  final TeacherFirebaseService _firebaseService = TeacherFirebaseService();
  bool _isDeleting = false;
  List<TeacherDetail> _teachers = [];

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    // Load the teacher data from Firestore
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('teachers').get();
    setState(() {
      _teachers = snapshot.docs.map((doc) => TeacherDetail.fromFirestore(doc)).toList();
    });
  }

  Future<void> _deleteTeacher(String teacherId) async {
    try {
      setState(() {
        _isDeleting = true;
      });
      await _firebaseService.deleteTeacherData(teacherId);
      widget.onDelete();
      await _loadTeachers();
    } catch (e) {
      print('Error deleting teacher: $e');
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  void _editTeacher(TeacherDetail teacher) {
    showDialog(
      context: context,
      builder: (context) => EditTeacherDialog(
        teacher: teacher,
        onUpdate: () async {
          await _loadTeachers();
          _showSuccessMessage();
        },
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teacher details updated successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teachers = widget.filteredTeachers ?? _teachers;

    return SizedBox(
      width: 800,
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
          decoration: const BoxDecoration(),
          dataRowColor: MaterialStateProperty.all(primaryColor),
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          headingRowDecoration: kMediumBoxDecoration,
          dividerThickness: 4,
          checkboxAlignment: Alignment.center,
          columns: [
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: const Text("Name", style: kMediumColoredTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: const Text("ID Number", style: kMediumColoredTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: const Text("Action", style: kMediumColoredTextStyle),
              ),
            ),
          ],
          rows: teachers.asMap().entries.map(
                (entry) {
              int index = entry.key;
              TeacherDetail teacher = entry.value;
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
                  DataCell(
                    Row(
                      children: [
                        if (teacher.profilePic != null)
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(teacher.profilePic!),
                          ),
                        if (teacher.profilePic == null)
                          const CircleAvatar(
                            radius: 10,
                            child: Icon(Icons.person),
                          ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeacherProfileScreen(
                                  teacher: teacher,
                                ),
                              ),
                            );
                          },
                          child: Text(teacher.name ?? '', style: kMediumColoredTextStyle),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(teacher.dob ?? '', style: kMediumColoredTextStyle),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editTeacher(teacher),
                        ),
                        _isDeleting
                            ? const CircularProgressIndicator()
                            : IconButton(
                          icon: const Icon(Icons.delete, color: primaryColor),
                          onPressed: teacher.id != null
                              ? () => _deleteTeacher(teacher.id!)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}