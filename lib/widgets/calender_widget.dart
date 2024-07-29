import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<dynamic>> markedDates = {
    DateTime(2024, 4, 9): ['Dummy Event 1'],
    DateTime(2024, 4, 8): ['Dummy Event 2'],
    DateTime(2024, 4, 10): ['Dummy Event 3'],
  };

  late final ValueNotifier<DateTime> _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier<DateTime>(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: 400,
            width: 500,
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 3, 20),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDay.value,
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.black),
                leftChevronIcon: Icon(Icons.arrow_back, color: Colors.black),
                rightChevronIcon: Icon(Icons.arrow_forward, color: Colors.black),
                formatButtonVisible: false,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.black),
                weekendStyle: TextStyle(color: Colors.black),
              ),
              selectedDayPredicate: (day) {
                return markedDates.containsKey(day);
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  final isMarked = markedDates.containsKey(date);
                  return Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMarked ? Colors.blue : Colors.transparent,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isMarked ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay.value = selectedDay;
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
