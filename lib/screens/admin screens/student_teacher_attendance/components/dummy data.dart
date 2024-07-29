import 'package:flutter/material.dart';

class Student {
  final String name;
  final String phone;
  final String class1;
  final String class2;
  final String class3;
  final String class4;

  Student({
    required this.name,
    required this.phone,
    required this.class1,
    required this.class2,
    required this.class3,
    required this.class4,
  });
}
class DummyData {
  static final List<Map<String, dynamic>> students = [
    {
      'name': 'John Doe',
      'phone': '123-456-7890',
      'class1': 'Present',
      'class2': 'Absent',
      'class3': 'Present',
      'class4': 'Present',
    },
    {
      'name': 'Jane Smith',
      'phone': '456-789-0123',
      'class1': 'Absent',
      'class2': 'Present',
      'class3': 'Present',
      'class4': 'Present',
    },
    {
      'name': 'Alice Johnson',
      'phone': '789-012-3456',
      'class1': 'Present',
      'class2': 'Absent',
      'class3': 'Present',
      'class4': 'Present',
    },
    {
      'name': 'Bob Williams',
      'phone': '012-345-6789',
      'class1': 'Present',
      'class2': 'Present',
      'class3': 'Absent',
      'class4': 'Present',
    },
    {
      'name': 'Eve Brown',
      'phone': '345-678-9012',
      'class1': 'Absent',
      'class2': 'Present',
      'class3': 'Absent',
      'class4': 'Absent',
    },
    {
      'name': 'Charlie Davis',
      'phone': '678-901-2345',
      'class1': 'Present',
      'class2': 'Present',
      'class3': 'Present',
      'class4': 'Present',
    },
    {
      'name': 'Grace Wilson',
      'phone': '901-234-5678',
      'class1': 'Absent',
      'class2': 'Absent',
      'class3': 'Absent',
      'class4': 'Absent',
    },
    {
      'name': 'David Miller',
      'phone': '234-567-8901',
      'class1': 'Absent',
      'class2': 'Absent',
      'class3': 'Absent',
      'class4': 'Absent',
    },
    {
      'name': 'Emma Martinez',
      'phone': '567-890-1234',
      'class1': 'Present',
      'class2': 'Present',
      'class3': 'Present',
      'class4': 'Absent',
    },
    {
      'name': 'Oliver Thompson',
      'phone': '890-123-4567',
      'class1': 'Absent',
      'class2': 'Present',
      'class3': 'Absent',
      'class4': 'Absent',
    },
    {
      'name': 'Sophia Garcia',
      'phone': '123-456-7890',
      'class1': 'Present',
      'class2': 'Present',
      'class3': 'Present',
      'class4': 'Absent',
    },
    {
      'name': 'Daniel Rodriguez',
      'phone': '456-789-0123',
      'class1': 'Absent',
      'class2': 'Absent',
      'class3': 'Present',
      'class4': 'Absent',
    }
    // Add more dummy data as needed
  ];
}

