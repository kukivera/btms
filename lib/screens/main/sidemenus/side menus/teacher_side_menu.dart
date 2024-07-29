import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/screen_provider.dart';
import '../../../../widgets/DrawerListTile.dart';

class TeachersSideMenu extends StatelessWidget {
  const TeachersSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shadowColor: Colors.cyan,
        backgroundColor: primaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 160,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: Colors.white,
                    height: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerListTile(
                title: "Home",
                icon: Icons.home,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('TeachersDashboard');
                },
              ),
              DrawerListTile(
                title: "Schedules",
                icon: Icons.schedule,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('TeacherSchedule');
                },
              ),
              DrawerListTile(
                title: "Grading",
                icon: Icons.grading,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('GradesRecorder');
                },
              ),
              DrawerListTile(
                title: "Attendance",
                icon: Icons.check_box_outlined,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('TeachersAttendanceRecorder');
                },
              ),
              DrawerListTile(
                title: "Add Resources",
                icon: Icons.add_box_outlined,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('ResourcesPage');
                },
              ),
              kLargeVerticalSpace,
              kLargeVerticalSpace,
              DrawerListTile(
                title: "Logout",
                icon: Icons.logout,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('ProgCard');
                },
              ),
            ],
          ),
        ));
  }
}
