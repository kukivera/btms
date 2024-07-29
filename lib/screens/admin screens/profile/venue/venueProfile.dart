import 'package:bruh_finance_tms/screens/admin%20screens/profile/venue/components/services.dart';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';
import 'components/registerModal.dart';
import 'components/venue_card.dart';

class VenueProfile extends StatefulWidget {
  const VenueProfile({super.key});

  @override
  State<VenueProfile> createState() => _VenueProfileState();
}

class _VenueProfileState extends State<VenueProfile> {

  final VenueService venueService = VenueService();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      builder: (context) => VenueRegisterModal());
                },
                child: const Text('Add Course', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
      kLargeVerticalSpace,
      Expanded(
        child: StreamBuilder<List<VenueModel>>(
          stream: venueService.getVenues(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.black),));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No venues found',style: TextStyle(color: Colors.black),));
            }
            final venues = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: venues.length,
              itemBuilder: (context, index ) {
                final venue = venues[index];
                return VenueSelectionCard(venue: venue);
              },
            );
          },
        ),
      ),
        ],
      ),
   );
  }
}



