import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/screen_provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                "assets/images/logo.png",
                color: Colors.lightBlueAccent,
                height: 15,
              ),
            ),
          ),
          // Your existing menu items
          DrawerListTile(
            title: "Home",
            icon: Icons.home,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('Home');
            },
          ),
          DrawerListTile(
            title: "Schedules",
            icon: Icons.schedule,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('Schedules');
            },
          ),
          DrawerListTile(
            title: "Payment Detail",
            icon: Icons.payments_rounded,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('AdminDashboard');

            },
          ),
          DrawerListTile(
            title: "Exam Booking",
            icon: Icons.bookmark_added_outlined,
            press: () {},
          ),
          DrawerListTile(
            title: "Rating",
            icon: Icons.rate_review,
            press: () {},
          ),
          SizedBox(
            height: 80,
          ),
          DrawerListTile(
            title: "Logout",
            icon: Icons.logout,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData? icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 14, 8),
        child: Icon(
          icon,
          color: primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: primaryColor),
      ),
    );
  }
}
