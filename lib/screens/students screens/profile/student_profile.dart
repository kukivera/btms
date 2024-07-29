import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../dashboard/components/classDetailTable.dart';





class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: bgColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // scolor: Colors.red,
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 40,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TODO: pull student data here for name
                            Text(
                              "Abel Endehsaw",
                              style: TextStyle(fontSize: 20, color: textColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Other data of the student that can be displayed",
                              style: TextStyle(fontSize: 10, color: textColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: bgColor,
                ),
                child: InfoContainer(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Container(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () {}, child: Text("go back")),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  const InfoContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 500,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Personal Information",
                                style: TextStyle(color: textColor),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "First Name",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Abel",
                                        style: TextStyle(color: textColor),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Last Name",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Endeshaw",
                                        style: TextStyle(color: textColor),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email Address",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "text@mail.com",
                                        style: TextStyle(color: textColor),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Phone Number",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "+251 9 12 34 56 78",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "City",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Addis Ababa",
                                        style: TextStyle(color: textColor),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Kebele",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Gulele",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sponser",
                                        style: TextStyle(color: textColor),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Tech bridge",
                                        style: TextStyle(color: textColor),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                          ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 500,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schooling Information",
                    style: TextStyle(color: textColor),
                  ),
                  ClassDetailTable()
                ],
              ),
            ))
      ],
    );
  }
}
