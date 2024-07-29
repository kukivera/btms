import 'package:flutter/material.dart';

import '../../constants.dart';

class CourseRow extends StatefulWidget {
  const CourseRow({super.key});

  @override
  _CourseRowState createState() => _CourseRowState();
}

class _CourseRowState extends State<CourseRow> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildElevatedButton('W01', 0),
        _buildElevatedButton('WCE', 1),
        _buildElevatedButton('WUE', 2),
      ],
    );
  }

  Widget _buildElevatedButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Text(
          text,
          style: kMediumTextStyle.copyWith(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
          elevation: _selectedIndex == index
              ? MaterialStateProperty.all(10.0)
              : MaterialStateProperty.all(0.0), // Apply elevation only to the selected button
          shadowColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
    );
  }
}
