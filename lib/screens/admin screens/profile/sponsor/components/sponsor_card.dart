
import 'package:bruh_finance_tms/screens/admin%20screens/profile/sponsor/components/services.dart';
import 'package:flutter/material.dart';
import 'package:bruh_finance_tms/constants.dart';


class NewSponsorCard extends StatelessWidget {
  final SponsorModel sponsor;

  const NewSponsorCard({super.key, required this.sponsor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 180,
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.castle_outlined, size: 50, color: primaryColor,),
            Text(sponsor.sponsorName, style: kMediumColoredBoldTextStyle, textAlign: TextAlign.center,),
            kMediumVerticalSpace,
            Text(sponsor.telephone, style: kMediumColoredBoldTextStyle,textAlign: TextAlign.center,),
            kMediumVerticalSpace,
          ],
        ),
      ),
    );
  }
}
