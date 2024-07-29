import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../controllers/screen_provider.dart';
import '../../../../widgets/DrawerListTile.dart';

class AdminSideMenu extends StatelessWidget {
  const AdminSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Drawer(
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
                        .setScreen('Dashboard');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.fromLTRB(16,0,16,0),
                    decoration: kBasicBoxDecoration.copyWith(color: Colors.white),
                    child: DropdownButton<String>(
                      dropdownColor: secondaryColor,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'student',
                          child: Text('Student',style: kMediumColoredTextStyle,),
                        ),
                        DropdownMenuItem(
                          value: 'teacher',
                          child: Text('Teacher',style: kMediumColoredTextStyle,),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == 'student') {
                          Provider.of<SelectedScreenProvider>(context, listen: false)
                              .setScreen('StudentRegistration');
                        } else if (value == 'teacher') {
                          Provider.of<SelectedScreenProvider>(context, listen: false)
                              .setScreen('TeacherRegistrationChoice');
                        }
                      },
                      hint: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.app_registration,color: primaryColor,),
                          kMediumHorizontalSpace,
                          Text('Registrar',style: kMediumColoredTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DrawerListTile(
                  title: "Programs",
                  icon: Icons.bookmarks_outlined,
                  press: () {
                    Provider.of<SelectedScreenProvider>(context, listen: false)
                        .setScreen('Programs');
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
                  title: "Profile",
                  icon: Icons.account_circle,
                  press: () {
                    Provider.of<SelectedScreenProvider>(context, listen: false)
                        .setScreen('Profile');
                  },
                ),
                DrawerListTile(
                  title: "Booking Date",
                  icon: Icons.payments_rounded,
                  press: () {
                    Provider.of<SelectedScreenProvider>(context, listen: false)
                        .setScreen('AdminBookingDate');
                  },
                ),


                DrawerListTile(
                  title: "Invoice",
                  icon: Icons.payments_rounded,
                  press: () {
                    Provider.of<SelectedScreenProvider>(context, listen: false)
                        .setScreen('Payment');
                  },
                ),

                DrawerListTile(
                  title: "Resources",
                  icon: Icons.sd_storage,
                  press: () {
                    Provider.of<SelectedScreenProvider>(context, listen: false)
                        .setScreen('ResourcesPage');
                  },
                ),

                SizedBox(
                  height: 80,
                ),
                DrawerListTile(
                  title: "Logout",
                  icon: Icons.logout,
                  press: () {
                    Provider.of<SelectedScreenProvider>(context, listen: false)
                        .setScreen('login');
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
