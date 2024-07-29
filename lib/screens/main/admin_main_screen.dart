

import 'package:bruh_finance_tms/screens/main/screen_choice.dart';
import 'package:bruh_finance_tms/screens/main/sidemenus/side%20menus/admin_side_menu.dart';

import 'package:bruh_finance_tms/screens/main/sidemenus/side%20menus/student_side_menu.dart';
import 'package:bruh_finance_tms/screens/main/sidemenus/side%20menus/teacher_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/screen_provider.dart';
import '../../responsive.dart';



class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedScreenProvider(), // Provide an instance of SelectedScreenProvider
      child: Scaffold(
        key: context.read<MenuAppController>().scaffoldKey,
        drawer: const AdminSideMenu(),
        body: SafeArea(
          child: Row(
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  flex:2 ,
                  child: AdminSideMenu(),
                ),
              Expanded(
                flex: 8,
                child: buildSelectedScreen(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
