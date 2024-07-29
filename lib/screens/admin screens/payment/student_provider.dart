import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bruh_finance_tms/screens/admin screens/registration/student/student data model/Student_model.dart';
class StudentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore;

  StudentProvider(this._firestore);

  Future<List<Students>> fetchStudentsBySections(List<DocumentReference> sectionRefs) async {
    List<Students> students = [];

    try {
      for (DocumentReference sectionRef in sectionRefs) {
        print('Querying for section: ${sectionRef.path}'); // Debugging log

        QuerySnapshot studentSnapshot = await _firestore
            .collection('students')
            .where('sections', arrayContains: sectionRef)
            .get();

        for (DocumentSnapshot doc in studentSnapshot.docs) {
          students.add(Students.fromFirestore(doc));
        }
      }
    } catch (e) {
      print('Error fetching students: $e');
    }

    return students;
  }
}
