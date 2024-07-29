import 'package:flutter/material.dart';

class StudentCalender extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const StudentCalender({super.key, required this.onDateSelected});

  @override
  _StudentCalenderState createState() => _StudentCalenderState();
}

class _StudentCalenderState extends State<StudentCalender> {
  final DateTime _currentDate = DateTime.now();

  void _selectDate(DateTime date) {
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 600,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '${_currentDate.year}, ${_currentDate.month}',
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: List.generate(42, (index) {
                final date = DateTime(
                  _currentDate.year,
                  _currentDate.month,
                  index - _currentDate.weekday + 1,
                );
                return InkWell(
                  onTap: () => _selectDate(date),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
