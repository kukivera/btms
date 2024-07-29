import 'package:bruh_finance_tms/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/screen_provider.dart';
import '../../../../widgets/header.dart';
import '../registration_option_card.dart';

class StudentRegistrationChoice extends StatefulWidget {
  const StudentRegistrationChoice({super.key});

  @override
  State<StudentRegistrationChoice> createState() =>
      _StudentRegistrationChoiceState();
}

class _StudentRegistrationChoiceState extends State<StudentRegistrationChoice> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          const Header(title:'Students Registration'),
          kLargeVerticalSpace,
          Row(
            children: [
              RegisterOptionCard(title: 'Student Database', icon: Icons.file_copy_rounded, onTap: () {


                  Provider.of<SelectedScreenProvider>(context, listen: false)
                      .setScreen('StudentDatabase');


              },),
              RegisterOptionCard(title: 'Register New +', icon: Icons.person_add_alt_1_rounded, onTap: () {

                Provider.of<SelectedScreenProvider>(context, listen: false)
                    .setScreen('StudentRegistrationForm');

              },)
            ],
          )
        ],
      ),
    );
  }
}

