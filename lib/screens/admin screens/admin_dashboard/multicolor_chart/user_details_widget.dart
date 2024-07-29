


import 'package:bruh_finance_tms/screens/admin%20screens/admin_dashboard/multicolor_chart/user_details_mini_card.dart';
import 'package:flutter/material.dart';


import '../../../../constants.dart';
import 'multiColorCharts.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({
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
            "Exam score Details",
            style: TextStyle(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          MultiColorChart(),
          UserDetailsMiniCard(
            color: Color(0xff0293ee),
            title: "High score",
            amountOfFiles: "%28.3",
            numberOfIncrease: "90 - 100" ,
          ),
          UserDetailsMiniCard(
            color: Color(0xfff8b250),
            title: "Good score",
            amountOfFiles: "%16.7",
            numberOfIncrease: "80 - 89" ,
          ),
          UserDetailsMiniCard(
            color: Color(0xff845bef),
            title: "Pass score",
            amountOfFiles: "%22.4",
            numberOfIncrease: "70 - 79",
          ),
          UserDetailsMiniCard(
            color: Color(0xff13d38e),
            title: "Failed",
            amountOfFiles: "%2.3",
            numberOfIncrease: "lower than 70",
          ),
        ],
      ),
    );
  }
}
