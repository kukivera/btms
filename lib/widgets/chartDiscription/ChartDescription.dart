import 'package:flutter/material.dart';

import '../../constants.dart';

class ChartDescription extends StatelessWidget {
  const ChartDescription({
    super.key,
    required this.done,
    required this.undone,
  });

  final String done;
  final String undone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.check_box,
              color: primaryColor,
            ),
            kSmallHorizontalSpace,
            Text(
              done,
              style: kSmallTextStyle.copyWith(color: primaryColor),
            ),
          ],
        ),
        kMediumHorizontalSpace,
        Row(
          children: [
            const Icon(Icons.check_box_outline_blank),
            kSmallHorizontalSpace,
            Text(
              undone,
              style: kSmallTextStyle.copyWith(color: primaryColor),
            ),
          ],
        )
      ],
    );
  }
}
