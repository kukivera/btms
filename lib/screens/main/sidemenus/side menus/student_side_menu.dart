import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/screen_provider.dart';
import '../../../../widgets/DrawerListTile.dart';
class StudentSideMenu extends StatelessWidget {
  const StudentSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(

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
                    height: 16,
                  ),
                ),
              ),
              const SizedBox(
               height:  30,
              ),
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
                      .setScreen('StudentSchedulePage');
                },
              ),
              DrawerListTile(
                title: "Payment Detail",
                icon: Icons.payments_rounded,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('StudentsPaymentDetailsPage');
                },
              ),
              DrawerListTile(
                title: "Exam Booking",
                icon: Icons.bookmark_added_outlined,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('BookExams');
                },
              ),
              DrawerListTile(
                title: "Rating",
                icon: Icons.rate_review,
                press: () {
                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('StudentsTeacherRating');
                },
              ),
              SizedBox(height: 40),
             ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(buttonColor),
                   elevation: MaterialStateProperty.all(15.0)
                 ),
                 onPressed: (){}, child: Text('Logout',style: TextStyle(
               color: Colors.white,
             ),))
            ],
          ),
        ),
      ),
    );
  }
}
