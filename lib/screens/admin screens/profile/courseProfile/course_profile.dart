
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';
import 'components/course_card.dart';
import 'components/registerModal.dart';
import 'components/services.dart';

class CourseProfiles extends StatefulWidget {
  const CourseProfiles({super.key});

  @override
  State<CourseProfiles> createState() => _CourseProfilesState();
}

class _CourseProfilesState extends State<CourseProfiles> {
  final CourseService courseService = CourseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: Center(
                child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),

                  onPressed: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                            )),
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: secondaryColor,
                        builder: (context) => CourseRegisterModal());
                  },
                  child: Text('Add Course', style: TextStyle(color: Colors.white)),
                ),
            ),
            ),
            Expanded(
              child: StreamBuilder<List<CourseModel>>(
                stream: courseService.getCourses(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {

                    return Center(child: Text('Error: ${snapshot.error}',style: kWhiteText,));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {

                    print(snapshot.data);
                    return const Center(child: Text('No courses found',style: kWhiteText,));
                  }
                  final courses = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context) ? 2 : 6,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 3,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseSelectionCard(course: course);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
