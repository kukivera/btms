import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id; // Document ID
  final String courseName;
  final String creditHour;
  final String description;
  final String courseCode;
  final int number_of_classes;
  final String? programId;
  final Timestamp createdAt; // Creation timestamp

  Course({
    required this.id,
    required this.courseName,
    required this.creditHour,
    required this.description,
    required this.courseCode,
    required this.number_of_classes,
    required this.programId,
    required this.createdAt,
  });

  factory Course.fromDocument(DocumentSnapshot doc) {
    return Course(
      id: doc.id, // Get document ID
      courseName: doc['courseName'],
      creditHour: doc['creditHour'],
      description: doc['description'],
      courseCode: doc['courseCode'],
      number_of_classes: doc['number_of_classes'],
      programId: doc['programId'],
      createdAt: doc['createdAt'],
    );
  }

  factory Course.fromFirestore(DocumentSnapshot doc) {
    return Course(
      id: doc.id, // Get document ID
      courseName: doc['courseName'],
      creditHour: doc['creditHour'],
      description: doc['description'],
      courseCode: doc['courseCode'],
      number_of_classes: doc['number_of_classes'],
      programId: doc['programId'],
      createdAt: doc['createdAt'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'courseName': courseName,
      'creditHour': creditHour,
      'description': description,
      'courseCode': courseCode,
      'number_of_classes': number_of_classes,
      'programId': programId,
      'createdAt': createdAt,
    };
  }
}
