import 'package:flutter/material.dart';

import '../../constants.dart';
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    required this.color,
    required this.percentage, required this.hight,
  });

  final Color? color;
  final int? percentage;
  final double hight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: hight,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Container(
                width: constraints.maxWidth * (percentage! / 100),
                height:hight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '$percentage%',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}