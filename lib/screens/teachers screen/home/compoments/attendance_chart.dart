
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../widgets/charts.dart';


class AttendanceChart extends StatelessWidget {
  const AttendanceChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Grade Overview",
            style: TextStyle(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(title: 'Grade Overview', description: 'Oversll Grade Overview', percentage: 80 ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.check_box,
                color: primaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Highest Grades',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.check_box_outline_blank),
              SizedBox(
                width: 10,
              ),
              Text(
                'Lowest Grade',
                style: TextStyle(color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }
}
