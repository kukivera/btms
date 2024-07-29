import 'package:flutter/material.dart';
import '../../../responsive.dart';
import '../../main/sidemenus/side menus/student_side_menu.dart';
import '../../students screens/dashboard/components/classDetailTable.dart';

class MyRatings extends StatefulWidget {
  const MyRatings({super.key});

  @override
  State<MyRatings> createState() => _MyRatingsState();
}

class _MyRatingsState extends State<MyRatings> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(

              child: SingleChildScrollView(
                child: ClassDetailTable(),
              ),
    );
  }
}
