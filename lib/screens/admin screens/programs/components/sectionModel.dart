import 'package:cloud_firestore/cloud_firestore.dart';

class Section {
  final String id;
  final String programId;
  final String batchId;
  final String name;
  final List<DocumentReference> students;
  final List<DocumentReference> courses;

  Section({
    required this.id,
    required this.programId,
    required this.batchId,
    required this.name,
    required this.students,
    required this.courses,
  });

  factory Section.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Section(
      id: doc.id,
      programId: data['programId'],
      batchId: data['batchId'],
      name: data['name'],
      students: List<DocumentReference>.from(data['students']),
      courses: List<DocumentReference>.from(data['courses']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'programId': programId,
      'batchId': batchId,
      'name': name,
      'students': students.map((ref) => ref.path).toList(),
      'courses': courses.map((ref) => ref.path).toList(),
    };
  }
}
