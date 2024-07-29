import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../widgets/header.dart';
import '../../main/sidemenus/side menus/student_side_menu.dart';



class StudentTeachersRating extends StatefulWidget {
  const StudentTeachersRating({super.key});

  @override
  _StudentTeachersRatingState createState() => _StudentTeachersRatingState();
}

class _StudentTeachersRatingState extends State<StudentTeachersRating> {
  List<Map<String, dynamic>> teachers = [
    {"name": "John", "course": "Math", "section": "A"},
    {"name": "Sara", "course": "Science", "section": "B"},
    {"name": "Mark", "course": "English", "section": "C"}
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
              child: Column(
                children: [
                  Header(title: 'Rating',),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      return TeacherProfile(teachers[index]);
                    },
                  )
                ],
              ),
            );
  }
}

class TeacherProfile extends StatelessWidget {
  final Map<String, dynamic> teacher;

  TeacherProfile(this.teacher);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => TeacherQuestions(teacher),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(defaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: Text(
                teacher["name"][0],
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${teacher["course"]} (${teacher["section"]})",
                    style: TextStyle(
                      color: Colors.black,
                    ),
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

class TeacherQuestions extends StatefulWidget {
  final Map<String, dynamic> teacher;

  TeacherQuestions(this.teacher);

  @override
  _TeacherQuestionsState createState() => _TeacherQuestionsState();
}

class _TeacherQuestionsState extends State<TeacherQuestions> {
  int currentQuestion = 0;
  String question1 = "What is their favorite subject?";
  String question2 = "How long have they been teaching?";
  String question3 = "What other subjects do they teach?";
  String question4 = "What is their educational background?";
  String question5 = "What do they like to do outside of school?";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.teacher["name"]),
          SizedBox(height: 16),
          Text(getQuestion()),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentQuestion != 0)
                TextButton(
                    onPressed: () {
                      setState(() {
                        currentQuestion--;
                      });
                    },
                    child: Text("Previous")),
              if (currentQuestion == 4)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Done"))
              else
                TextButton(
                    onPressed: () {
                      setState(() {
                        currentQuestion++;
                      });
                    },
                    child: Text("Next")),
            ],
          )
        ],
      ),
    );
  }

  String getQuestion() {
    switch (currentQuestion) {
      case 0:
        return question1;
      case 1:
        return question2;
      case 2:
        return question3;
      case 3:
        return question4;
      case 4:
        return question5;
      default:
        return "";
    }
  }
}
