import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference coursesCollection =
FirebaseFirestore.instance.collection('courses');


class CourseService {

  Future<void> addCourse({
    required String courseName,
    required String creditHour,
    required String description,
    required String courseCode,
    required int number_of_classes,
    required String? programId,
  }) async {
    try {
      Map<String, dynamic> courseData = {
        'courseName': courseName,
        'creditHour': creditHour,
        'description': description,
        'courseCode': courseCode,
        'number_of_classes': number_of_classes,
        'programId': programId,
        'createdAt': Timestamp.now(),
      };

      await coursesCollection.add(courseData);
    } catch (e) {
      print('Error adding course: $e');
    }
  }


  Stream<List<CourseModel>> getCourses() {
    return coursesCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CourseModel.fromDocument(doc);
      }).toList();
    });
  }


  Future<void> updateCourse({
    required String courseId,
    String? courseName,
    String? creditHour,
    String? description,
    String? courseCode,
    String? number_of_classes,
    String? programId,
  }) async {
    try {
      Map<String, dynamic> updatedData = {};

      if (courseName != null) updatedData['courseName'] = courseName;
      if (creditHour != null) updatedData['creditHour'] = creditHour;
      if (description != null) updatedData['description'] = description;
      if (courseCode != null) updatedData['courseCode'] = courseCode;
      if (number_of_classes != null) updatedData['number_of_classes'] = number_of_classes;
      if (programId != null) updatedData['program'] = programId;

      await coursesCollection.doc(courseId).update(updatedData);
    } catch (e) {
      print('Error updating course: $e');
    }
  }



  Future<void> deleteCourse(String courseId) async {
    try {
      await coursesCollection.doc(courseId).delete();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }



}


class CourseModel {
  final String id; // Document ID
  final String courseName;
  final String creditHour;
  final String description;
  final String courseCode;
  final int number_of_classes;
  final String? programId;

  CourseModel({
    required this.id,
    required this.courseName,
    required this.creditHour,
    required this.description,
    required this.courseCode,
    required this.number_of_classes,
    required this.programId,
  });

  factory CourseModel.fromDocument(DocumentSnapshot doc) {
    return CourseModel(
      id: doc.id, // Get document ID
      courseName: doc['courseName'],
      creditHour: doc['creditHour'],
      description: doc['description'],
      courseCode: doc['courseCode'],
      number_of_classes: doc['number_of_classes'],
      programId: doc['programId'],
    );
  }




}





