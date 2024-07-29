import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';

class ProgramSelectorRow extends StatelessWidget {
  final String activeProgram;
  final String program1;
  final String program2;
  final Color program2Color;
  final Color program1Color;
  final Function(String) setActiveProgram;

  const ProgramSelectorRow({
    super.key,
    required this.activeProgram,
    required this.program1,
    required this.program2,
    required this.setActiveProgram,
    required this.program2Color,
    required this.program1Color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setActiveProgram(program1);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: kMediumBoxDecoration,
            child: Row(
              children: [
                Text(
                  program1,
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                ),
                kMediumHorizontalSpace,
                CircleAvatar(
                  radius: 8,
                  backgroundColor: program1Color,
                ),
              ],
            ),
          ),
        ),
        kMediumHorizontalSpace, // Add some spacing between texts
        GestureDetector(
          onTap: () {
            setActiveProgram(program2);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration:kMediumBoxDecoration,
            child: Row(
              children: [
                Text(
                  program2,
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                ),
                kMediumHorizontalSpace,
                CircleAvatar(
                  radius: 8,
                  backgroundColor: program2Color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
