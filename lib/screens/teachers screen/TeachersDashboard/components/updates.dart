import 'package:flutter/material.dart';

import '../../../../constants.dart';



class Updates extends StatefulWidget {
  const Updates({super.key});

  @override
  State<Updates> createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Updates',
            style: kLargeColoredBoldTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: kMediumBoxDecoration,
          ),
        ),
      ],
    );
  }
}
