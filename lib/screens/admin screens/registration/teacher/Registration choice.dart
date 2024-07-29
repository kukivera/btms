import 'package:bruh_finance_tms/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/screen_provider.dart';
import '../../../../widgets/header.dart';
import '../registration_option_card.dart';

class TeacherRegistrationChoice extends StatefulWidget {
  const TeacherRegistrationChoice({super.key});

  @override
  State<TeacherRegistrationChoice> createState() =>
      _StudentRegistrationChoiceState();
}

class _StudentRegistrationChoiceState extends State<TeacherRegistrationChoice> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Header(title:'Teachers Registration'),
          kLargeVerticalSpace,
          Row(
            children: [
              RegisterOptionCard(title: 'Tutors Database', icon: Icons.file_copy_rounded, onTap: () {


                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('TeacherDatabase');


              },),
              RegisterOptionCard(title: 'Register New +', icon: Icons.person_add_alt_1_rounded, onTap: () {

                Provider.of<SelectedScreenProvider>(context, listen: false)
                    .setScreen('TeacherRegistrationForm');

              },)
            ],
          )
        ],
      ),
    );
  }
}

