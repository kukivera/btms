import 'package:flutter/material.dart';

import '../../../../../constants.dart';




class StudentCard extends StatelessWidget {
  final VoidCallback onTap;

  StudentCard({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: primaryColor, borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Student Database',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Icon(
                Icons.folder,
                color: Colors.cyan.shade700,
                size: 40,
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
