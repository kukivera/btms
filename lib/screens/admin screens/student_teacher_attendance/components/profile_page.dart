import 'package:flutter/material.dart';

import '../../../../constants.dart';



class ProfileScreen extends StatelessWidget {
  final String name;
  final String phone;

  const ProfileScreen({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: $name',
              style: kLargeTextStyle,
            ),
            Text(
              'Phone: $phone',
              style: kLargeTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
