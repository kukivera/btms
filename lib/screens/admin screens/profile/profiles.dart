import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/screen_provider.dart';
import 'all_profiles_card.dart';

class AllProfiles extends StatefulWidget {
  const AllProfiles({super.key});

  @override
  State<AllProfiles> createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 600,
        padding: const EdgeInsets.all(16),
        child: ProfilesCard(
          profiles: [
            Profile(
                text: 'Courses',
                icon: Icons.menu_book_outlined,
                onPressed: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('CourseProfile');
                }),
            Profile(
                text: 'Venue',
                icon: Icons.home_work_rounded,
                onPressed: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('VenueProfile');
                }),
            Profile(
              text: 'Sponsor',
              icon: Icons.monetization_on_outlined,
              onPressed: () {
                Provider.of<SelectedScreenProvider>(context, listen: false)
                    .setScreen('SponsorProfile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
