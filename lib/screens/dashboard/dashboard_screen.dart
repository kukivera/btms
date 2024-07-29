
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';
import 'components/header.dart';

import 'components/classDetailTable.dart';
import 'components/myCoursesBiulder.dart';
import 'components/paymentOverview.dart';
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String activeProgram = 'CII Certificate';

  void setActiveProgram(String program) {
    setState(() {
      activeProgram = program;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title:' Student',),
            SizedBox(height: defaultPadding),
            Text(
              "Welcome Name",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
            ),
            SizedBox(height: 10,),
            Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setActiveProgram('CII Certificate');
                    },
                    child: Text(
                      'CII Certificate',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: activeProgram == 'CII Certificate' ? Colors.blue : Colors.black,

                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Add some spacing between texts
                  GestureDetector(
                    onTap: () {
                      setActiveProgram('CISI');
                    },
                    child: Text(
                      'CISI',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: activeProgram == 'CISI' ? Colors.blue : Colors.black,

                      ),
                    ),
                  ),
                ]
            ),
            SizedBox(height: 20,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyCourses(),
                      SizedBox(height: defaultPadding),
                      ClassDetailTable(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) PaymentOverview(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: PaymentOverview(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
