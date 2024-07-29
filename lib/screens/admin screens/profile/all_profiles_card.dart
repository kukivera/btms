import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Profile {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  Profile({required this.text, required this.icon, required this.onPressed});
}

class ProfilesCard extends StatefulWidget {
  final List<Profile> profiles;

  const ProfilesCard({super.key, required this.profiles});

  @override
  State<ProfilesCard> createState() => _ProfilesCardState();
}

class _ProfilesCardState extends State<ProfilesCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              crossAxisCount: constraints.maxWidth > 400 ? 2 : 1, // Adjust number of columns based on available width
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              children: widget.profiles.map((profile) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200), // Maximum width of 200
                  child: GestureDetector(
                    onTap: profile.onPressed,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              profile.icon,
                              color: primaryColor,
                              size: 80,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              profile.text,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
