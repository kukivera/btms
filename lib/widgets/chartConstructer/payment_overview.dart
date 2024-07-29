import 'package:bruh_finance_tms/widgets/chartDiscription/ChartDescription.dart';
import 'package:bruh_finance_tms/widgets/charts.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class PaymentOverview extends StatelessWidget {
  const PaymentOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration:kBasicBoxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: defaultPadding),
          Chart(
            title: 'Payment Detail',
            description: 'Overall student payment detail',
            percentage: 65,
          ),
          ChartDescription(done: 'Paid', undone: 'Unpaid'),
        ],
      ),
    );
  }
}
