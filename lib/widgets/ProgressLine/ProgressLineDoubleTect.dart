import 'package:flutter/material.dart';

import '../../constants.dart';
class ProgressLineDoubleText extends StatelessWidget {
  const ProgressLineDoubleText({
    Key? key,
    required this.color,
    required this.percentage,
    required this.height,
    required this.description,
  }) : super(key: key);

  final Color? color;
  final int? percentage;
  final double height;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final double percentageWidth =
                availableWidth * (percentage! / 100);

            return Stack(
              children: [
                Container(
                  width: percentageWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      description,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (percentage! >= 30) // Check if percentage is greater than or equal to 30
                  Positioned(
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Opacity(
                        opacity: percentage! >= 30 ? 1.0 : 0.0, // Set opacity based on percentage
                        child: Text(
                          '$percentage%',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}