
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../teacher data model/teachers_model.dart';
import '../teacher registartion/teachers_registration_services.dart';
import 'classDetailTable.dart';


class TeacherDatabase extends StatefulWidget {
  const TeacherDatabase({Key? key}) : super(key: key);

  @override
  State<TeacherDatabase> createState() => _TeacherDatabaseState();
}

class _TeacherDatabaseState extends State<TeacherDatabase> {
  final TeacherFirebaseService _firebaseService = TeacherFirebaseService();
  List<TeacherDetail>? _teachers;
  List<TeacherDetail>? _filteredTeachers;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeacherData();
    _searchController.addListener(() {
      _filterTeachers(_searchController.text);
    });
  }

  Future<void> _fetchTeacherData() async {
    try {
      List<TeacherDetail> teachers = await _firebaseService.fetchTeacherData();
      setState(() {
        _teachers = teachers;
        _filteredTeachers = teachers;
      });
    } catch (e) {
      print('Error fetching teacher data: $e');
    }
  }

  void _filterTeachers(String query) {
    List<TeacherDetail>? filteredList = _teachers?.where((teacher) {
      return teacher.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredTeachers = filteredList;
    });
  }

  void _onDelete() {
    _fetchTeacherData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 800,
          height: 500,
          child: TeacherTable(
            filteredTeachers: _filteredTeachers,
            onDelete: _onDelete,
          ),
        ),
      ],
    );
  }
}
