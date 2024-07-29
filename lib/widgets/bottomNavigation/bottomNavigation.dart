import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/screen_provider.dart';


class NavigationService {
  final BuildContext context;

  NavigationService(this.context);

  void onItemTapped(int index) {
    if (index == 1) {
      Provider.of<SelectedScreenProvider>(context, listen: false)
          .setScreen('Teacher');
    } else {
      Provider.of<SelectedScreenProvider>(context, listen: false)
          .setScreen('Attendances');
    }
  }
}
