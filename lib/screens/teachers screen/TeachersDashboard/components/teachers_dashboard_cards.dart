import 'package:bruh_finance_tms/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class TeacherDashboardCards extends StatelessWidget {
  const TeacherDashboardCards({
    super.key,
    required this.content,
  });
  final Widget content;
  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
          height: 250,
          child: content,
        ),
      ),
    );
  }else{
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
            height: 250,
            child: content,
          ),
        ),
      );
    }
    }
}