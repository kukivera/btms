import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class PaymentOverview extends StatelessWidget {
  const PaymentOverview({
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
            "Payment overview",
            style: TextStyle(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(Icons.check_box, color: primaryColor,),
              SizedBox(width: 10,),
              Text('Paid Amount', style: TextStyle(
                  color: Colors.black
              ),),

            ],
          ),
          Row(
            children: [
              Icon(Icons.check_box_outline_blank),
              SizedBox(width: 10,),
              Text('Unpaid Amount', style: TextStyle(
                color: Colors.black
              ),),

            ],
          )
        ],
      ),
    );
  }
}
