import 'package:flutter/material.dart';

class CourseButtonRow extends StatefulWidget {
  final List<String> courseLabels;
  final List<VoidCallback> onPressed;

  CourseButtonRow({required this.courseLabels, required this.onPressed});

  @override
  _CourseButtonRowState createState() => _CourseButtonRowState();
}

class _CourseButtonRowState extends State<CourseButtonRow> {
  int selectedIndex = -1; // initially no button is selected

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(
          widget.courseLabels.length,
              (index) => _buildElevatedButton(
            index,
            widget.courseLabels[index],
            widget.onPressed[index],
          ),
        ),
      ),
    );
  }


  Widget _buildElevatedButton(int index, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
          onPressed(); // Call the onPressed callback
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(selectedIndex == index ? Colors.lightBlueAccent : Colors.grey),
          shadowColor: MaterialStateProperty.all(Colors.black),
          elevation: MaterialStateProperty.all(selectedIndex == index ? 10.0 : 0.0),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
