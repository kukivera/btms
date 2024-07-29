import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'package:flutter/material.dart';

class InvoiceToDetail extends StatelessWidget {
  final Map<String, dynamic> customerData = {
    'customerName': 'Customer Name',
    'customerMobileNumber': '+1234567890',
    'customerEmail': 'customer@example.com',
    'customerAddress': 'Customer Address',
  };

   InvoiceToDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 230,
      decoration: BoxDecoration(
        // color: secondaryColor,
        border: Border(left: BorderSide(width: 2, color: primaryColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bill to",
              style: kMediumColoredTextStyle,
            ),
            Text(
              customerData['customerName'],
              style: kMediumColoredTextStyle,
            ),
            Text(
              "Mob: ${customerData['customerMobileNumber']}",
              style: kMediumColoredTextStyle,
            ),
            Text(
              "Email: ${customerData['customerEmail']}",
              style: kMediumColoredTextStyle,
            ),
            Text(
              customerData['customerAddress'],
              style: kMediumColoredTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}