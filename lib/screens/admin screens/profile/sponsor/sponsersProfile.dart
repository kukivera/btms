
import 'package:flutter/material.dart';
import 'package:bruh_finance_tms/constants.dart';



import '../../../../responsive.dart';
import 'components/registerModal.dart';
import 'components/services.dart';
import 'components/sponsor_card.dart';


class SponsorProfiles extends StatefulWidget {
  const SponsorProfiles({super.key});

  @override
  State<SponsorProfiles> createState() => _SponsorProfilesState();
}

class _SponsorProfilesState extends State<SponsorProfiles> {
  final SponsorService sponsorService = SponsorService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: Center(
                child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),

                  onPressed: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                            )),
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: secondaryColor,
                        builder: (context) => RegisterModal());
                  },
                  child: const Text('Add Course', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<SponsorModel>>(
                stream: sponsorService.getSponsors(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error) ;
                    return Center(child: Text('Error: ${snapshot.error}',style: kMediumColoredTextStyle,));

                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {

                    print(snapshot.data);
                    return const Center(child: Text('No Sponsors found',style: kMediumColoredTextStyle,));
                  }
                  final sponsors = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context) ? 2 : 6,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 3,
                    ),
                    itemCount: sponsors.length,
                    itemBuilder: (context, index) {
                      final sponsor = sponsors[index];
                      return NewSponsorCard(sponsor: sponsor);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
