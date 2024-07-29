import 'package:bruh_finance_tms/widgets/barComplition.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

import '../chartDiscription/ChartDescription.dart';
import '../charts.dart';

class PersonalPaymentOverview extends StatelessWidget {
  const PersonalPaymentOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: kBasicBoxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CompletionBar(percentage: 50, paid: 80000, totalPayment:120000 ,),
          kLargeVerticalSpace,
          ChartDescription(done: 'Paid Amount', undone: 'Unpaid Amount',),
        ],
      ),
    );
  }
}

