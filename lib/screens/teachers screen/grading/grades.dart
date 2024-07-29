
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package
import '../../../../controllers/user_provider.dart';
import 'package:bruh_finance_tms/screens/admin screens/registration/student/student data model/Student_model.dart';
import 'package:bruh_finance_tms/screens/admin screens/programs/components/sectionModel.dart';

import '../../../constants.dart';


class GradesRecorder extends StatefulWidget {
  const GradesRecorder({super.key});

  @override
  State<GradesRecorder> createState() => _GradesRecorderState();
}

class _GradesRecorderState extends State<GradesRecorder> {
  Map<String, double> examResults = {};
  String searchQuery = '';
  String? expandedScheduleId;
  List<Students> currentStudents = [];
  List<DocumentSnapshot> schedules = [];
  final TextEditingController maxMarksController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodaysSchedulesForTutor();
  }

  void _fetchTodaysSchedulesForTutor() async {
    setState(() {
      _isLoading = true;
    });
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
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching schedules: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch schedules.')));
    }
  }

  void _fetchStudentsForSchedule(String sectionId) async {
    setState(() {
      _isLoading = true;
    });
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
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch students.')));
    }
  }

  Future<void> _submitResults({
    required String sectionId,
    required String courseId,
    required String className,
    required int classNumber,
    required List<Students> students,
  }) async {
    setState(() {
      _isLoading = true;
    });
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      double maxMarks = double.tryParse(maxMarksController.text) ?? 0.0;

      for (var student in students) {
        double studentMarks = examResults[student.id!] ?? 0.0;
        double percentage = (studentMarks / maxMarks) * 100;

        QuerySnapshot existingResults = await FirebaseFirestore.instance
            .collection('classResults')
            .where('sectionId', isEqualTo: sectionId)
            .where('courseId', isEqualTo: courseId)
            .where('studentId', isEqualTo: student.id)
            .where('className', isEqualTo: className)
            .where('classNumber', isEqualTo: classNumber)
            .get();

        if (existingResults.docs.isNotEmpty) {
          var resultDoc = existingResults.docs.first;
          await resultDoc.reference.update({
            'maxMarks': maxMarks,
            'studentMarks': studentMarks,
            'percentage': percentage,
          });
        } else {
          await FirebaseFirestore.instance.collection('classResults').add({
            'sectionId': sectionId,
            'courseId': courseId,
            'studentId': student.id,
            'className': className,
            'classNumber': classNumber,
            'classDate': Timestamp.fromDate(today),
            'maxMarks': maxMarks,
            'studentMarks': studentMarks,
            'percentage': percentage,
          });
        }
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Results submitted successfully.')));
    } catch (e) {
      print('Error recording results: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit results.')));
    }
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
        title: Text('Schedules for ${userProvider.firstName}', style: kMediumColoredTextStyle),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultsPage()),
              );
            },
            child: const Text('View Results', style: kWhiteText),
          ),
        ],
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
              decoration: InputDecoration(
                labelText: 'Search Students',
                labelStyle: kMediumColoredTextStyle,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: maxMarksController,
              decoration: InputDecoration(
                labelText: 'Enter Maximum Marks',
                labelStyle: kMediumColoredTextStyle,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                setState(() {});
              },
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
                      title: Text(schedule['className'] ?? 'Class Name Not Available', style: kMediumColoredTextStyle),
                      subtitle: Text(
                        'Date: ${_formatDate(schedule['date'])}\nClass Number: ${schedule['classNumber']}', style: kMediumColoredTextStyle,
                      ),
                      onTap: () {
                        setState(() {
                          expandedScheduleId = isExpanded ? null : schedule.id;
                          if (!isExpanded) {
                            _fetchStudentsForSchedule(schedule['sectionId']);
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

    double? maxMarks = double.tryParse(maxMarksController.text);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Name', style: kMediumColoredTextStyle)),
              DataColumn(label: Icon(Icons.fact_check_outlined, color: primaryColor)),
              DataColumn(label: Text('Update', style: kMediumColoredTextStyle)),
            ],
            rows: filteredStudents.map((student) {
              return DataRow(cells: [
                DataCell(Text('${student.firstName ?? 'N/A'} ${student.lastName ?? ''}', style: kMediumColoredTextStyle)),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        double? marks = double.tryParse(value);
                        if (marks != null && marks <= (maxMarks ?? double.infinity)) {
                          setState(() {
                            examResults[student.id!] = marks;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Marks cannot exceed maximum marks')),
                          );
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.update, color: primaryColor),
                    onPressed: _isLoading
                        ? null
                        : () => _submitResults(
                      sectionId: schedule['sectionId'],
                      courseId: schedule['courseId'],
                      className: schedule['className'],
                      classNumber: schedule['classNumber'],
                      students: [student],
                    ),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                textStyle: kWhiteText,
              ),
              onPressed: _isLoading || maxMarks == null
                  ? null
                  : () => _submitResults(
                sectionId: schedule['sectionId'],
                courseId: schedule['courseId'],
                className: schedule['className'],
                classNumber: schedule['classNumber'],
                students: filteredStudents,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit All Results'),
            ),
          ],
        ),
      ],
    );
  }
}



class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late Future<List<DocumentSnapshot>> fetchResults;

  @override
  void initState() {
    super.initState();
    fetchResults = _fetchResultsFromFirestore();
  }

  Future<List<DocumentSnapshot>> _fetchResultsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('classResults')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching results: $e');
      return []; // Return an empty list or handle error as needed
    }
  }

  Future<Students> fetchStudentData(String studentId) async {
    try {
      DocumentSnapshot studentDoc =
      await FirebaseFirestore.instance.collection('students').doc(studentId).get();

      if (studentDoc.exists) {
        return Students.fromFirestore(studentDoc);
      } else {
        throw Exception('Student with ID $studentId not found');
      }
    } catch (e) {
      print('Error fetching student data: $e');
      throw e;
    }
  }

  Color _getColorBasedOnPercentage(double percentage) {
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 70 && percentage < 90) {
      return Colors.blue; // Adjust colors as per your requirement
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('Results Page'),
        actions: [
          FutureBuilder<List<DocumentSnapshot>>(
            future: fetchResults,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return IconButton(
                  icon: Icon(Icons.warning),
                  onPressed: () {},
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<DocumentSnapshot> results = snapshot.data!;
                int totalStudents = results.length;
                int passedStudents = results.where((result) {
                  double percentage = result.get('percentage') ?? 0.0;
                  return percentage >= 70;
                }).length;
                double passingPercentage = totalStudents > 0
                    ? (passedStudents / totalStudents) * 100
                    : 0.0;

                return IconButton(
                  icon: Icon(Icons.check_circle),
                  tooltip: 'Passing Percentage: ${passingPercentage.toStringAsFixed(2)}%',
                  onPressed: () {},
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.warning),
                  onPressed: () {},
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<DocumentSnapshot> results = snapshot.data!;

            return DataTable(
              columns: const [

                DataColumn(label: Text('Student Name',style: kMediumColoredTextStyle,)),
                DataColumn(label: Text('Result',style: kMediumColoredTextStyle,)),
                DataColumn(label: Text('%',style: kMediumColoredTextStyle,)),
              ],
              rows: results.map((result) {
                String className = result.get('className') ?? 'N/A';
                String studentId = result.get('studentId');
                double studentMarks = result.get('studentMarks') ?? 0.0;
                double percentage = result.get('percentage') ?? 0.0;
                String studentFirstName = ''; // Placeholder for student first name
                String studentLastName = ''; // Placeholder for student last name

                return DataRow(
                  cells: [

                    DataCell(FutureBuilder<Students>(
                      future: fetchStudentData(studentId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          Students student = snapshot.data!;
                          return Text('${student.firstName} ${student.lastName}');
                        } else {
                          return const Text('N/A',style: kMediumColoredTextStyle,);
                        }
                      },
                    )),
                    DataCell(Text(studentMarks.toString(),style: kMediumColoredTextStyle,)),
                    DataCell(
                      Text(
                        '${percentage.toStringAsFixed(2)}%',
                        style: TextStyle(color: _getColorBasedOnPercentage(percentage)),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('No results found.',style: kMediumColoredTextStyle,));
          }
        },
      ),
    );
  }
}