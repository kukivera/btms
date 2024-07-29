class AdminScheduleView extends StatefulWidget {
  const AdminScheduleView({super.key, required this.selectedSection});
  final String selectedSection;

  @override
  State<AdminScheduleView> createState() => _AdminScheduleViewState();
}

class _AdminScheduleViewState extends State<AdminScheduleView> {
  Future<List<Course>> fetchSectionCourses(String sectionId) async {
    try {
      final sectionSnapshot = await FirebaseFirestore.instance
          .collection('sections')
          .doc(sectionId)
          .get();

      if (!sectionSnapshot.exists) {
        throw Exception("Section not found");
      }

      List<DocumentReference> courseRefs =
          List<DocumentReference>.from(sectionSnapshot['courses']);
      List<Course> courses = [];

      for (DocumentReference courseRef in courseRefs) {
        DocumentSnapshot courseSnapshot = await courseRef.get();

        if (courseSnapshot.exists) {
          courses.add(Course.fromDocument(courseSnapshot));
        } else {
          print('Course document not found: ${courseRef.id}');
        }
      }

      return courses;
    } catch (e) {
      print('Error fetching courses: $e');
      throw e; // Re-throw the error to be caught by FutureBuilder
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllSchedules(String sectionId, String courseId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('sectionId', isEqualTo: sectionId)
          .where('courseId', isEqualTo: courseId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No schedule found for this course in this section.');
      } else {
        List<Map<String, dynamic>> schedules = [];
        for (var doc in querySnapshot.docs) {
          var scheduleData = doc.data();
          List<DocumentReference> teacherRefs = List<DocumentReference>.from(scheduleData['assignedTutors']);
          List<Map<String, dynamic>> teachers = [];

          for (var teacherRef in teacherRefs) {
            var teacherSnapshot = await teacherRef.get();
            if (teacherSnapshot.exists) {
              teachers.add(teacherSnapshot.data() as Map<String, dynamic>);
            } else {
              print('Teacher document not found: ${teacherRef.id}');
            }
          }

          scheduleData['teachers'] = teachers;
          schedules.add(scheduleData);
        }
        return schedules;
      }
    } catch (e) {
      print('Error fetching schedules: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section Schedule and Students', style: kWhiteText),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 100,
          child: FutureBuilder<List<Course>>(
            future: fetchSectionCourses(widget.selectedSection),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No courses found.'));
              } else {
                List<Course> courses = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        try {
                          var schedules = await fetchAllSchedules(widget.selectedSection, courses[index].id);
                          showDialog(
                            context: context,
                            builder: (context) => ScheduleTableDialog(schedules: schedules),
                          );
                        } catch (e) {
                          print('Error displaying schedule: $e');
                        }
                      },
                      child: SizedBox(
                        width: 250,
                        height: 200,
                        child: Card(
                          elevation: 8.0,
                          color: secondaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  courses[index].courseName,
                                  style: kMediumColoredBoldTextStyle,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Code: ${courses[index].courseCode}\nCredit Hours: ${courses[index].creditHour}',
                                  style: kMediumColoredTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ScheduleTableDialog extends StatelessWidget {
  final List<Map<String, dynamic>> schedules;

  const ScheduleTableDialog({required this.schedules});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Schedule Details'),
      content: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Class Number', style: kMediumColoredBoldTextStyle)),
            DataColumn(label: Text('Class Name', style: kMediumColoredBoldTextStyle)),
            DataColumn(label: Text('Venue', style: kMediumColoredBoldTextStyle)),
            DataColumn(label: Text('Date', style: kMediumColoredBoldTextStyle)),
            DataColumn(label: Text('Teachers', style: kMediumColoredBoldTextStyle)),
          ],
          rows: schedules.map((schedule) {
            DateTime date = (schedule['date'] as Timestamp).toDate();
            String formattedDate = DateFormat.yMMMd().add_jm().format(date);

            return DataRow(
              cells: [
                DataCell(Text(schedule['classNumber']?.toString() ?? "N/A", style: kMediumColoredTextStyle)),
                DataCell(Text(schedule['className'] ?? "N/A", style: kMediumColoredTextStyle)),
                DataCell(Text(schedule['venue'] ?? "N/A", style: kMediumColoredTextStyle)),
                DataCell(Text(formattedDate, style: kMediumColoredTextStyle)),
                DataCell(
                  Row(
                    children: (schedule['teachers'] as List<Map<String, dynamic>>).map((teacher) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(teacher['imageUrl'] ?? 'https://example.com/placeholder.jpg'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
}