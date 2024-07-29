import 'package:flutter/material.dart';

import '../../../constants.dart';


class RegisterOptionCard extends StatelessWidget {
  const RegisterOptionCard({
    super.key, required this.title, required this.icon, required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0,8.0,8.0,8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration:
          kMediumBoxDecoration.copyWith(color: secondaryColor),
          width: 200,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: kMediumBoxDecoration.copyWith(color: primaryColor),

                padding: const EdgeInsets.all(16.0),
                child:  Text(
                  title,
                  style: kWhiteText,
                ),
              ),
              Icon(
                icon,
                size: 70,
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
