import 'package:flutter/material.dart';

import '../../../../constants.dart';

class InvoiceFromDetail extends StatelessWidget {
  final String companyName = "Bruh Finance";
  final String mobileNumber = "+251911223344";
  final String email = "info@bruhfinance.com";
  final String address = "Addis Ababa, Ethiopia";


  const InvoiceFromDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 230,
      decoration: BoxDecoration(
        // color: secondaryColor,
        border: Border(right: BorderSide(width: 2, color: primaryColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bill by",
              style: kMediumColoredTextStyle,
            ),
            Text(
              companyName,
              style: kMediumColoredTextStyle,
            ),
            Text(
              "Mob: $mobileNumber",
              style: kMediumColoredTextStyle,
            ),
            Text(
              "Email: $email",
              style: kMediumColoredTextStyle,
            ),
            Text(
              address,
              style: kMediumColoredTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
