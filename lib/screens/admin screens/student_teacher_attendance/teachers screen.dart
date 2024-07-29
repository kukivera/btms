
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../widgets/bottomNavigation/bottomNavigation.dart';
import '../../../widgets/course_dropdown/program_dropdown.dart';
import '../../../widgets/header.dart';
import '../../../widgets/searchSortWidget/search_widget.dart';
import '../../../widgets/searchSortWidget/sort.dart';
import '../../../widgets/studentsTable/student_table.dart';
import 'components/dummy data.dart';



class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _StudentTeacherAttendanceState();
}

class _StudentTeacherAttendanceState extends State<TeachersScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredStudents = [];
  String? sortedColumn = 'Student Name';
  bool ascending = true;
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredStudents = DummyData
        .students; // Assuming you have a class DummyData with a static list students
  }

  void filterStudents(String query) {
    setState(() {
      filteredStudents = DummyData.students.where((student) {
        final studentName = student['name'].toLowerCase();
        return studentName.contains(query.toLowerCase());
      }).toList();
    });
  }

  void sortStudents(String columnName) {
    setState(() {
      if (sortedColumn == columnName) {
        ascending = !ascending;
      } else {
        sortedColumn = columnName;
        ascending = true;
      }

      filteredStudents.sort((a, b) {
        if (columnName == 'Percentage') {
          final percentageA = calculatePercentage(a);
          final percentageB = calculatePercentage(b);
          return ascending
              ? percentageA.compareTo(percentageB)
              : percentageB.compareTo(percentageA);
        } else if (columnName == 'Student Name') {
          final nameA = a['name'].toLowerCase();
          final nameB = b['name'].toLowerCase();
          return ascending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
        } else {
          return ascending
              ? a[columnName].compareTo(b[columnName])
              : b[columnName].compareTo(a[columnName]);
        }
      });
    });
  }

  double calculatePercentage(Map<String, dynamic> student) {
    final presentCount = [
      student['class1'],
      student['class2'],
      student['class3'],
      student['class4']
    ]
        .where((status) => status == 'Present')
        .length;
    const totalClasses = 4;
    return (presentCount / totalClasses) * 100;
  }

  void _onItemTapped(int index) {
    // Instantiate NavigationService and call its method
    NavigationService navigationService = NavigationService(context);
    navigationService.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Teachers',
                  style: kLargeTextStyle,
                ),

                const Padding(
                  padding: kRegularPadding,
                  child: Header(title: 'Teachers Attendance',),
                ),
                const Padding(
                  padding: kRegularPadding,
                  child: ProgramDropdown(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        child: SearchWidget(
                          onChanged: filterStudents,
                        ),
                      ),
                      kMediumHorizontalSpace,
                      CustomDropdownButton(
                        value: sortedColumn,
                        onChanged: (String? newValue) {
                          sortStudents(newValue!);
                        },
                        items: const ['Student Name', 'Percentage'],
                        icon: Icons.sort,
                      ),
                    ],
                  ),
                ),
                if (Responsive.isDesktop(context))      CustomDataTable(students: filteredStudents),

              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlueAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined, color: Colors.black),
              label: 'Students',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.border_color, color: Colors.black),
              label: 'Teachers',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}