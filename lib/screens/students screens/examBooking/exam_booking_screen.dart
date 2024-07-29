
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../widgets/calender_widget.dart';
import '../../../widgets/course_dropdown/program_dropdown.dart';
import '../../../widgets/header.dart';
import '../../main/sidemenus/side menus/student_side_menu.dart';
import '../dashboard/components/classDetailTable.dart';



class BookExams extends StatefulWidget {
  const BookExams({super.key});

  @override
  State<BookExams> createState() => _BookExamsState();
}

class _BookExamsState extends State<BookExams> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
                children: [
                  Header(title: 'Exam Boking',),
                  SizedBox(
                    height: 20,
                  ),
                  ProgramDropdown(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Booked Exam Date",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              height: 400,
                              width: 400,
                              child: Column(
                                children: [
                                  ClassDetailTable(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              "Booked Exam Date",
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                              width: 400,
                              height: 450,
                              child: Column(
                                children: [
                                     const Calendar(),
                                  ElevatedButton(
                                      onPressed: (() {}),
                                      child: Text("Save Date"))
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(width: 100, height: 20, child: TextField()),
                            SizedBox(height: 12),
                            ElevatedButton(
                                onPressed: (() {}), child: Text("Save Grade")),
                          ],
                        ),
                      ],
                    ),
                  ),
        ],
      ),
    );
  }
}
