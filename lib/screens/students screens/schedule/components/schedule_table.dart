import 'package:flutter/material.dart';

class ScheduleTable extends StatelessWidget {
  final DateTime? selectedDate;
  final List<Map<String, dynamic>> scheduleData;

  ScheduleTable({required this.selectedDate, required this.scheduleData});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Class Name', style: TextStyle(color: Colors.black))),
        DataColumn(label: Text('Date', style: TextStyle(color: Colors.black))),
        DataColumn(label: Text('Full Day Or Half Day', style: TextStyle(color: Colors.black))),
        DataColumn(label: Text('Venue', style: TextStyle(color: Colors.black))),
      ],
      rows: scheduleData.map((schedule) {
        final isSelected = selectedDate != null && schedule['dates'].contains(selectedDate!.day);
        return DataRow(
          color: isSelected ? MaterialStateProperty.all(Colors.blue.withOpacity(0.2)) : null,
          cells: [
            DataCell(Text(schedule['className'], style: const TextStyle(color: Colors.black))),
            DataCell(Text(schedule['date'], style: const TextStyle(color: Colors.black))),
            DataCell(Text(schedule['fullDay'], style: const TextStyle(color: Colors.black))),
            DataCell(Text(schedule['venue'], style: const TextStyle(color: Colors.black))),
          ],
        );
      }).toList(),
    );
  }
}