
import 'package:flutter/material.dart';
import 'package:bruh_finance_tms/widgets/chartConstructer/payment_overview.dart';
import 'package:bruh_finance_tms/widgets/chartConstructer/attendance_overview.dart';

import '../../../constants.dart';
import '../../../widgets/course_dropdown/program_dropdown.dart';
import '../../../widgets/header.dart';

import 'barChart/barChart.dart';
import 'multicolor_chart/user_details_widget.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(title: 'Dashboard',),
            kMediumVerticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  kMediumVerticalSpace,
                  ProgramDropdown(),
                ],
              ),
            ),
            kMediumVerticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AttendanceOverview(),
                          ),
                          kMediumHorizontalSpace,
                          Expanded(
                            flex: 2,
                            child: PaymentOverview(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TeachersAttendance(),
                      ),
                    ],
                  ),
                ),
                kMediumHorizontalSpace,
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: UserDetailsWidget(),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TeachersAttendance extends StatelessWidget {
  const TeachersAttendance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Teachers Attendance',
                  style:kMediumTextStyle,
                ),
              ),
              BarGraph(),
            kMediumVerticalSpace
            ],
          ),
          const CompletionColumn(),
        ],
      ),
    );
  }
}

class CompletionColumn extends StatelessWidget {
  const CompletionColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Class completion',
              style: kMediumTextStyle),
          Text('97 % ',
              style:kLargeTextStyle ),
          Text('Completed',
              style: kMediumTextStyle),
        ],
      ),
    );
  }
}
