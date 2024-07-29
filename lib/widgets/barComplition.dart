import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CompletionBar extends StatelessWidget {
  final double percentage;
  final double paid;
  final double totalPayment;


  const CompletionBar({super.key,
    required this.percentage,
    required this.paid,
    required this.totalPayment,

  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth;

    if (screenWidth > 800) {
      maxWidth = 240;
    } else {
      maxWidth = screenWidth * 0.9; // Set the maximum width to 90% of the screen width
    }

    double width = maxWidth * (percentage / 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You paid $paid of $totalPayment \n Program Payment ',
          style: kMediumColoredBoldTextStyle,
        ),
        SizedBox(height: 10),
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Center(
                child: Text(
                  '$percentage%',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}