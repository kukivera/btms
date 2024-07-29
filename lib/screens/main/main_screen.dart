

import 'package:bruh_finance_tms/screens/main/screen_choice.dart';
import 'package:bruh_finance_tms/screens/main/sidemenus/side%20menus/admin_side_menu.dart';

import 'package:bruh_finance_tms/screens/main/sidemenus/side%20menus/student_side_menu.dart';
import 'package:bruh_finance_tms/screens/main/sidemenus/side%20menus/teacher_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/screen_provider.dart';
import '../../controllers/user_provider.dart';
import '../../responsive.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Provide UserProvider
        ChangeNotifierProvider(create: (context) => SelectedScreenProvider()), // Provide SelectedScreenProvider
      ],
      child: Consumer<MenuAppController>(
        builder: (context, menuAppController, child) {
          return Scaffold(
            key: menuAppController.scaffoldKey,
            drawer: const StudentSideMenu(),
            body: SafeArea(
              child: Row(
                children: [
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      flex: 2,
                      child: StudentSideMenu(),
                    ),
                  Expanded(
                    flex: 8,
                    child: buildSelectedScreen(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}