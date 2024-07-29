import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/screen_provider.dart';
import '../../../../widgets/DrawerListTile.dart';
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
            title:"Home",
            icon: Icons.home,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('AdminDashboard');
            },
          ),
          DrawerListTile(
            title: "Programs",
            icon: Icons.bookmarks_outlined,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('Courses');
            },
          ),
          DrawerListTile(
            title: "Attendances",
            icon: Icons.collections_bookmark_outlined,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('Attendances');
            },
          ),
          DrawerListTile(
            title: "Exam Result",
            icon: Icons.grade_outlined,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('ExamResult');
            },
          ),

          DrawerListTile(
            title: "Payment Detail",
            icon: Icons.payments_rounded,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('Payment');

            },
          ),
          DrawerListTile(
            title: "Student Registration",
            icon: Icons.payments_rounded,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('StudentRegistration');

            },
          ),
          DrawerListTile(
            title: "Teachers Attendance",
            icon: Icons.check_box_outlined,
            press: () {
              Provider.of<SelectedScreenProvider>(context, listen: false)
                  .setScreen('TeachersAttendance');

            },
          ),

          SizedBox(
            height: 80,
          ),
          DrawerListTile(
            title: "Logout",
            icon: Icons.logout,
            press: () {Provider.of<SelectedScreenProvider>(context, listen: false)
                .setScreen('ProgCard');},
          ),
        ],
      ),
    );
  }
}

