import 'dart:io' as io;
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../student data model/Student_model.dart';



class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //TODO: add Service to upload student image
  Future<String> uploadStudentImage(Uint8List imageBytes) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('student_images/${DateTime.now()}.jpg');
      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Error uploading student image: $e');
    }
  }

//TODO: Add Service to add student image
  Future<String> registerStudent(
      Map<String, dynamic> studentData, Uint8List? imageBytes) async {
    try {
      String? imageUrl;
      if (imageBytes != null) {
        imageUrl = await uploadStudentImage(imageBytes);
      }

      Map<String, dynamic> studentDataWithImage = {
        ...studentData,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'role': 'student', // Add the 'role' field with the value 'student'
        'sections': [], // Initialize the 'sections' as an empty array
      };

      // Create a new user account with email and password
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: studentData['email'],
        password: studentData['password'],
      );

      // Update the user's display name
      String userId = userCredential.user!.uid;
      await userCredential.user!.updateDisplayName(
          '${studentData['firstName']} ${studentData['lastName']}');

      // Add to the 'users' collection
      await _db.collection('users').doc(userId).set(studentDataWithImage);

      // Add to the 'students' collection
      DocumentReference studentDocRef =
      await _db.collection('students').add(studentDataWithImage);

      // Get the ID generated for the new student document and update it in the document itself
      String studentId = studentDocRef.id;
      await studentDocRef.update({'id': studentId});

      return studentId;
    } catch (e) {
      print('Error adding student: $e');
      throw Exception('Error adding student: $e');
    }
  }

  //TODO: service to fetch student data

  Future<List<Students>> fetchStudentData() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('students').get();
      List<Students> students = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Students(
          profilePic: data['imageUrl'],
          name: '${data['firstName']} ${data['lastName']}',
          firstName: '${data['firstName']}',
          middleName: '${data['middleName']}',
          lastName: '${data['lastName']}',
          email: '${data['email']}',
          secondaryphone: data['secondaryPhone'] ?? '',
          instalment: data['instalment'] ?? '',
          companyName: data['companyName'] ?? '',
          position: data['position'] ?? '',
          sponsor: data['sponsor'] ?? '',
          phoneNumber: '${data['phoneNumber']}',
          dob: data['dob'] ?? '',
          program: data['program'] ?? '',
          id: doc.id,
          role: data['role'] ?? '',
        );
      }).toList();
      return students;
    } catch (e) {
      throw Exception('Error fetching student data: $e');
    }
  }


  //TODO: service to update students

   Future<void> updateStudentData(
      String studentId, Map<String, dynamic> studentData, Uint8List? imageBytes) async {
    try {
      String? imageUrl;
      if (imageBytes != null) {
        imageUrl = await uploadStudentImage(imageBytes);
      }

      Map<String, dynamic> studentDataWithImage = {
        ...studentData,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      // Update the student's data in the 'students' collection
      await _db.collection('students').doc(studentId).update(studentDataWithImage);

      // Update the user's display name in FirebaseAuth
      if (studentData.containsKey('firstName') && studentData.containsKey('lastName')) {
        String displayName = '${studentData['firstName']} ${studentData['lastName']}';
        QuerySnapshot usersSnapshot = await _db
            .collection('users')
            .where('role', isEqualTo: 'student')
            .get();
        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          if (userData.containsValue(studentId)) {
            String userId = userDoc.id;
            User user = FirebaseAuth.instance.currentUser!;
            await user.updateDisplayName(displayName);
            await _db.collection('users').doc(userId).update({
              'firstName': studentData['firstName'],
              'lastName': studentData['lastName'],
            });
          }
        }
      }
    } catch (e) {
      throw Exception('Error updating student data: $e');
    }
  }

  //TODO: add service to fetch the programs collection
  Future<List<String>> fetchPrograms() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('programs').get();
      List<String> programs =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      return programs;
    } catch (e) {
      throw Exception('Error fetching programs: $e');
    }
  }

  //TODO: add service to fetch the sponsors collection
  Future<List<String>> fetchSponsors() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('sponsors').get();
      List<String> sponsors =
          querySnapshot.docs.map((doc) => doc['sponsorName'] as String).toList();
      return sponsors;
    } catch (e) {
      throw Exception('Error fetching sponsors: $e');
    }
  }

//TODO: Add Service to Fetch Courses Collection
  Future<List<String>> fetchCourses() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('courses').get();
      List<String> courses =
          querySnapshot.docs.map((doc) => doc['courseName'] as String).toList();
      courses.sort(); // Sort the list of courses
      return courses;
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      // Delete the student document from the 'students' collection
      await _db.collection('students').doc(studentId).delete();

      // Delete the student's data from the 'users' collection
      QuerySnapshot usersSnapshot = await _db
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsValue(studentId)) {
          await _db.collection('users').doc(userDoc.id).delete();
        }
      }
    } catch (e) {
      throw Exception('Error deleting student: $e');
    }
  }
}
