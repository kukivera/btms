
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../models/MyFiles.dart';
import '../../../../widgets/ProgressLine/ProgressLine.dart';



class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.info,
  });

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration:kBasicBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            info.title!,
            style: const TextStyle(
              color: primaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: Colors.green,
            percentage: info.percentage, hight: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                info.totalStorage! ,
                style: kMediumTextStyle)
            ],
          )
        ],
      ),
    );
  }
}
