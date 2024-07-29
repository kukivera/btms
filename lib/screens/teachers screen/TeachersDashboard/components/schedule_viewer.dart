import 'package:flutter/material.dart';

import '../../../../constants.dart';



class ScheduleViewer extends StatelessWidget {
  const ScheduleViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Schedules',
            style: kLargeColoredBoldTextStyle,
          ),
        ),
        Container(
          width: 300,
          height: 200,
          decoration: kMediumBoxDecoration,
          child: const Center(
              child: Icon(
                Icons.calendar_month,
                size: 120,
                color: primaryColor,
              )),
        ),
      ],
    );
  }
}