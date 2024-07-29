
import 'package:bruh_finance_tms/models/Program.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';


class ProgramCard extends StatelessWidget {
  const ProgramCard({
    super.key,
    required this.info,
  });

  final ProgramInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.svgSrc!,
                  colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black, BlendMode.srcIn),
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Text(
            info.title!,
            style: kMediumColoredBoldTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                info.totalStorage! ,
                style: kSmallTextStyle)
            ],
          )
        ],
      ),
    );
  }
}
