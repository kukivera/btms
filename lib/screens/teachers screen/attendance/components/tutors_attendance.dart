
import 'package:bruh_finance_tms/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package
import '../../../../controllers/user_provider.dart';
import 'package:bruh_finance_tms/screens/admin screens/registration/student/student data model/Student_model.dart';
import 'package:bruh_finance_tms/screens/admin screens/programs/components/sectionModel.dart';

class TutorsAttendance extends StatefulWidget {
  const TutorsAttendance({super.key});

  @override
  State<TutorsAttendance> createState() => _TutorsAttendanceState();
}

class _TutorsAttendanceState extends State<TutorsAttendance> {
  Map<String, bool> morningAttendance = {};
  Map<String, bool> afternoonAttendance = {};
  String searchQuery = '';
  String? expandedScheduleId;
  String? selectedAttendanceType;
  List<Students> currentStudents = [];
  List<DocumentSnapshot> schedules = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodaysSchedulesForTutor();
  }

  void _fetchTodaysSchedulesForTutor() async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('assignedTutors', arrayContains: FirebaseFirestore.instance.collection('teachers').doc(userProvider.additionalId!))
          .where('date', isEqualTo: Timestamp.fromDate(today))
          .get();

      setState(() {
        schedules = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching schedules: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch schedules.')));
    }
  }

  void _fetchStudentsForSchedule(String sectionId) async {
    try {
      DocumentSnapshot sectionDoc = await FirebaseFirestore.instance.collection('sections').doc(sectionId).get();

      if (!sectionDoc.exists) {
        throw Exception('Section with ID $sectionId does not exist');
      }

      Section section = Section.fromFirestore(sectionDoc);

      List<DocumentSnapshot> studentDocs = await Future.wait(
        section.students.map((studentRef) => studentRef.get()).toList(),
      );

      setState(() {
        currentStudents = studentDocs.map((doc) => Students.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print('Error fetching students: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch students.')));
    }
  }

  void _loadAttendanceData(String scheduleId) async {
    try {
      QuerySnapshot morningSnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('scheduleId', isEqualTo: scheduleId)
          .where('type', isEqualTo: 'morning')
          .get();
      QuerySnapshot afternoonSnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('scheduleId', isEqualTo: scheduleId)
          .where('type', isEqualTo: 'afternoon')
          .get();

      Map<String, bool> newMorningAttendance = {};
      Map<String, bool> newAfternoonAttendance = {};

      for (var doc in morningSnapshot.docs) {
        newMorningAttendance[doc['studentId']] = doc['attendanceStatus'];
      }
      for (var doc in afternoonSnapshot.docs) {
        newAfternoonAttendance[doc['studentId']] = doc['attendanceStatus'];
      }

      setState(() {
        morningAttendance = newMorningAttendance;
        afternoonAttendance = newAfternoonAttendance;
      });

      // Debug print the loaded attendance maps
      morningAttendance.forEach((key, value) {
        print('Morning attendance - Student $key status: $value');
      });
      afternoonAttendance.forEach((key, value) {
        print('Afternoon attendance - Student $key status: $value');
      });

    } catch (e) {
      print('Error loading attendance data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load attendance data.')));
    }
  }

  Future<void> _submitAttendance({
    required String sectionId,
    required String courseId,
    required String className,
    required int classNumber,
    required List<Students> students,
    required String type,
  }) async {
    setState(() {
      _isLoading = true;
    });
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      for (var student in students) {
        QuerySnapshot existingAttendanceSnapshot = await FirebaseFirestore
            .instance
            .collection('attendance')
            .where('sectionId', isEqualTo: sectionId)
            .where('courseId', isEqualTo: courseId)
            .where('studentId', isEqualTo: student.id)
            .where('classDate', isEqualTo: Timestamp.fromDate(today))
            .where('classHour', isEqualTo: type == 'morning')
            .where('type', isEqualTo: type)
            .get();

        if (existingAttendanceSnapshot.docs.isNotEmpty) {
          // Update existing attendance entry
          var existingDoc = existingAttendanceSnapshot.docs.first;
          await FirebaseFirestore.instance.collection('attendance').doc(existingDoc.id).update({
            'attendanceStatus': type == 'morning' ? morningAttendance[student.id] ?? false : afternoonAttendance[student.id] ?? false,
          });
        } else {
          // Add new attendance entry
          await FirebaseFirestore.instance.collection('attendance').add({
            'sectionId': sectionId,
            'courseId': courseId,
            'studentId': student.id,
            'className': className,
            'classNumber': classNumber,
            'classDate': Timestamp.fromDate(today),
            'classHour': type == 'morning',
            'attendanceStatus': type == 'morning' ? morningAttendance[student.id] ?? false : afternoonAttendance[student.id] ?? false,
            'type': type,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Attendance for $type submitted successfully.')));
    } catch (e) {
      print('Error recording attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit $type attendance.')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAllAttendance({
    required String sectionId,
    required String courseId,
    required String className,
    required int classNumber,
    required List<Students> students,
    required String type,
  }) async {
    await _submitAttendance(
      sectionId: sectionId,
      courseId: courseId,
      className: className,
      classNumber: classNumber,
      students: students,
      type: type,
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Date Not Available';
    DateTime dateTime = timestamp.toDate();
    return DateFormat.yMMMd().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules for ${userProvider.firstName}',style: kMediumColoredTextStyle,),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Students',
                labelStyle: kMediumColoredTextStyle,
                border: OutlineInputBorder(
                ),
              ),
            ),
          ),
          Expanded(
            child: schedules.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                var schedule = schedules[index];
                bool isExpanded = expandedScheduleId == schedule.id;

                return Column(
                  children: [
                    ListTile(
                      title: Text(schedule['className'] ?? 'Class Name Not Available',style: kMediumColoredTextStyle,),
                      subtitle: Text(
                        'Date: ${_formatDate(schedule['date'])}\nClass Number: ${schedule['classNumber']}',style: kMediumColoredTextStyle,
                      ),
                      onTap: () {
                        setState(() {
                          expandedScheduleId = isExpanded ? null : schedule.id;
                          if (!isExpanded) {
                            _fetchStudentsForSchedule(schedule['sectionId']);
                            _loadAttendanceData(schedule.id);
                          }
                        });
                      },
                    ),
                    if (isExpanded) _buildStudentTable(schedule),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTable(DocumentSnapshot schedule) {
    var filteredStudents = currentStudents
        .where((student) =>
    (student.firstName?.toLowerCase().contains(searchQuery) ?? false) ||
        (student.lastName?.toLowerCase().contains(searchQuery) ?? false))
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: 'morning',
              groupValue: selectedAttendanceType,
              onChanged: (value) {
                setState(() {
                  selectedAttendanceType = value;
                });
              },
              fillColor: MaterialStateProperty.all<Color>(secondaryColor), // Change to your desired color
            ),
            const Text('Morning', style: kMediumColoredTextStyle),
            Radio<String>(
              value: 'afternoon',
              groupValue: selectedAttendanceType,
              onChanged: (value) {
                setState(() {
                  selectedAttendanceType = value;
                });
              },
              fillColor: MaterialStateProperty.all<Color>(secondaryColor), // Change to your desired color
            ),
            const Text('Afternoon', style: kMediumColoredTextStyle),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name',style: kMediumColoredTextStyle,)),
                DataColumn(label: Icon(Icons.fact_check_outlined
                ,color: primaryColor,
                )),
                DataColumn(label: Text('Update')),
              ],
              rows: filteredStudents.map((student) {
                bool isPresent = selectedAttendanceType == 'morning'
                    ? morningAttendance[student.id!] ?? false
                    : afternoonAttendance[student.id!] ?? false;

                return DataRow(cells: [
                  DataCell(Text('${student.firstName ?? 'N/A'} ${student.lastName ?? ''}',style: kMediumColoredTextStyle,)),
                  DataCell(
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedAttendanceType == 'morning') {
                            morningAttendance[student.id!] = !isPresent;
                          } else {
                            afternoonAttendance[student.id!] = !isPresent;
                          }
                        });
                      },
                      child: Icon(
                        isPresent ? Icons.circle : Icons.circle_outlined,
                        color: isPresent ? primaryColor : secondaryColor,
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.update,color: primaryColor,),
                      onPressed: selectedAttendanceType == null
                          ? null
                          : () => _submitAttendance(
                        sectionId: schedule['sectionId'],
                        courseId: schedule['courseId'],
                        className: schedule['className'],
                        classNumber: schedule['classNumber'],
                        students: [student],
                        type: selectedAttendanceType!,
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor),
              ),
              onPressed: selectedAttendanceType == null || _isLoading
                  ? null
                  : () => _submitAllAttendance(
                sectionId: schedule['sectionId'],
                courseId: schedule['courseId'],
                className: schedule['className'],
                classNumber: schedule['classNumber'],
                students: filteredStudents,
                type: selectedAttendanceType!,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: primaryColor)
                  : const Text('Submit Attendance',style: kWhiteText,),
            ),
          ],
        ),
      ],
    );
  }
}