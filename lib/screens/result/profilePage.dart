import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String? name;
  final String? result;

  ProfilePage({required this.name, required this.result});

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
              'Result: $result',
              style:kLargeTextStyle,
            ),
            // Add more profile information as needed
          ],
        ),
      ),
    );
  }
}
