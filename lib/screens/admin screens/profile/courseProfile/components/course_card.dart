import 'package:bruh_finance_tms/screens/admin%20screens/profile/courseProfile/components/services.dart';
import 'package:flutter/material.dart';
import 'package:bruh_finance_tms/constants.dart';


class CourseSelectionCard extends StatelessWidget {
  final CourseModel course;
  final CourseService courseService = CourseService();

  CourseSelectionCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              course.courseName,
              style: kMediumColoredBoldTextStyle,
            ),
            kMediumVerticalSpace,
            CircleAvatar(
              radius: 20,
              child: Text(
                course.courseCode.length > 3 ? course.courseCode.substring(0, 3) : course.courseCode,
                style: kWhiteText,
              ),
              backgroundColor: primaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,

              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: primaryColor,),
                  onPressed: () => _showUpdateDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete , color: primaryColor,),
                  onPressed: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Course', style: kWhiteText,),
          content: const Text('Are you sure you want to delete this course?', style: kWhiteText,),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: kWhiteText,),
            ),
            TextButton(
              onPressed: () async {
                await courseService.deleteCourse(course.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: kWhiteText,),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final TextEditingController courseNameController = TextEditingController(text: course.courseName);
    final TextEditingController creditHourController = TextEditingController(text: course.creditHour);
    final TextEditingController descriptionController = TextEditingController(text: course.description);
    final TextEditingController courseCodeController = TextEditingController(text: course.courseCode);
    final TextEditingController numberOfClassesController = TextEditingController(text: course.number_of_classes.toString());
    final TextEditingController programController = TextEditingController(text: course.programId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          title: const Text('Update Course', style: kWhiteText,),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: courseNameController,
                  decoration: InputDecoration(
                      labelText: 'Course Name'
                  ),

                ),
                TextField(
                  controller: creditHourController,
                  decoration: InputDecoration(labelText: 'Credit Hour'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description'),
                ),
                TextField(
                  controller: courseCodeController,
                  decoration: InputDecoration(labelText: 'Course Code'),
                ),
                TextField(
                  controller: numberOfClassesController,
                  decoration: InputDecoration(labelText: 'Number of Classes'),
                ),
                TextField(
                  controller: programController,
                  decoration: InputDecoration(labelText: 'Program'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel' , style: kWhiteText,),
            ),
            TextButton(
              onPressed: () async {
                await courseService.updateCourse(
                  courseId: course.id,
                  courseName: courseNameController.text,
                  creditHour: creditHourController.text,
                  description: descriptionController.text,
                  courseCode: courseCodeController.text,
                  number_of_classes: numberOfClassesController.text,
                  programId: programController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update', style: kWhiteText,),
            ),
          ],
        );
      },
    );
  }
}

