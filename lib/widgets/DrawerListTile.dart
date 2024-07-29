import 'package:flutter/material.dart';

import '../constants.dart';


class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData? icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        decoration: kBasicBoxDecoration.copyWith(color: Colors.white), // You can adjust the radius as needed
        child: ListTile(
          onTap: press,

          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 14, 0),
            child: Icon(
              icon,
              color: primaryColor,
              size: 20, // Assuming you want black icons on a white background
            ),
          ),
          title: Text(
            title,
            style: kMediumColoredBoldTextStyle, // Assuming you want black text on a white background
          ),
        ),
      ),
    );
  }
}
