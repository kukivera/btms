
import 'package:bruh_finance_tms/widgets/addAttendance/teachers_attendance.dart';
import 'package:bruh_finance_tms/widgets/chartConstructer/pesrsonal_payment_overview.dart';
import 'package:bruh_finance_tms/widgets/programSelection/program_selection.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../widgets/header.dart';
import 'components/classDetailTable.dart';
import 'components/myCoursesBiulder.dart';




class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: 'Dashboard',),
            kLargeVerticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ProgramSelectorRow(activeProgram: 'CII Certificate', program1: 'CII Certificate', program2: 'CISI', setActiveProgram: setActiveProgram, program2Color: Colors.orange, program1Color: Colors.green,) ,
                      kLargeVerticalSpace,
                      const MyCourses(),
                      const SizedBox(height: defaultPadding),
                      const ClassDetailTable(),
                      if (!Responsive.isDesktop(context))const PaymentAndUpdates(),

                    ],
                  ),
                ),
                if (Responsive.isDesktop(context))
                   const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: PaymentAndUpdates()
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class PaymentAndUpdates extends StatefulWidget {
  const PaymentAndUpdates({super.key});

  @override
  State<PaymentAndUpdates> createState() => _PaymentAndUpdatesState();
}

class _PaymentAndUpdatesState extends State<PaymentAndUpdates> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Preview' ,style: kMediumColoredBoldTextStyle,),
        kMediumVerticalSpace,
        const PersonalPaymentOverview(),
        kMediumVerticalSpace,
        const Text('Updates' ,style: kMediumColoredBoldTextStyle,),
        kSmallVerticalSpace,
        Container(
          width: double.infinity,
          height:260,
          decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
        )


      ],
    );
  }
}
