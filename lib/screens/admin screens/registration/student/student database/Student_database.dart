import 'package:flutter/material.dart';



import '../student registation/services.dart';
import '../student data model/Student_model.dart';
import 'classDetailTable.dart';

class StudentDatabase extends StatefulWidget {
  const StudentDatabase({super.key});

  @override
  State<StudentDatabase> createState() => _StudentDatabaseState();
}

class _StudentDatabaseState extends State<StudentDatabase> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Students>? _students;
  List<Students>? _filteredStudents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
    _searchController.addListener(() {
      _filterStudents(_searchController.text);
    });
  }

  Future<void> _fetchStudentData() async {
    try {
      List<Students> students = await _firebaseService.fetchStudentData();
      setState(() {
        _students = students;
        _filteredStudents = students;
      });
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  void _filterStudents(String query) {
    List<Students>? filteredList = _students?.where((student) {
      return student.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredStudents = filteredList;
    });
  }

  void _onDelete() {
    _fetchStudentData();
  }

  void _onUpdate() {
    _fetchStudentData();
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
          child: StudentTable(
            filteredStudents: _filteredStudents,
            onDelete: _onDelete,
            onUpdate: _onUpdate, // Pass the onUpdate callback
          ),
        ),
      ],
    );
  }
}
