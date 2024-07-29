import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../teacher data model/teachers_model.dart';

class TeacherFirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // TODD: Add service to add teacher image

  Future<String> uploadTeacherImage(Uint8List imageBytes) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('teacher_images/${DateTime.now()}.jpg');
      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Error uploading student image: $e');
    }
  }

// TODO: Add service to register teachers
  Future<void> registerTeachers(
      Map<String, dynamic> teachersData, Uint8List? imageBytes) async {
    try {
      // Check if the 'teachers' collection exists
      bool teachersCollectionExists =
          (await _db.collection('teachers').limit(1).get()).docs.isNotEmpty;

      // If the 'teachers' collection doesn't exist, create it by adding a dummy document and then deleting it
      if (!teachersCollectionExists) {
        DocumentReference dummyDoc = await _db.collection('teachers').add({});
        await dummyDoc.delete();
      }

      String? imageUrl;
      if (imageBytes != null) {
        imageUrl = await uploadTeacherImage(imageBytes);
      }

      // Add the 'role' field with the value 'teacher' and the 'imageUrl' field
      Map<String, dynamic> teachersDataWithRole = {
        ...teachersData,
        'role': 'teacher',
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      // Create a new user account with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: teachersData['email'],
        password: teachersData['password'],
      );

      // Update the user's display name
      String userId = userCredential.user!.uid;
      await userCredential.user!.updateDisplayName(
          '${teachersData['firstName']} ${teachersData['lastName']}');

      // Add to the 'users' collection
      await _db.collection('users').doc(userId).set(teachersDataWithRole);

      // Add to the 'teachers' collection
      await _db.collection('teachers').add(teachersDataWithRole);
    } catch (e) {
      print('Error adding teacher: $e');
      throw Exception('Error adding teacher: $e');
    }
  }

  //TODO: Add service to fetch teachers data

  Future<List<TeacherDetail>> fetchTeacherData() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('teachers').get();
      List<TeacherDetail> teachers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TeacherDetail(
          id: doc.id,
          profilePic: data['imageUrl'] ?? null,
          name: '${data['firstName']} ${data['lastName']}',
          firstName: '${data['firstName']}',
          lastName: '${data['lastName']}',
          middleName: '${data['middleName']}',
          email: '${data['email']}',
          secondaryphone: data['secondaryPhone'] ?? '',
          instalment: data['instalment'] ?? '',
          companyName: data['companyName'] ?? '',
          position: data['position'] ?? '',
          qualification: data['qualification'] ?? '',
          phoneNumber: '${data['phoneNumber']}',
          dob: data['dob'] ?? '',
          program: data['program'] ?? '',
          role: data['role'] ?? '',
        );
      }).toList();
      return teachers;
    } catch (e) {
      throw Exception('Error fetching teacher data: $e');
    }
  }

  // TODO: Add service to update teachers

  Future<void> updateTeacherData(
      String teacherId, Map<String, dynamic> teacherData, Uint8List? imageBytes) async {
    try {
      String? imageUrl;
      if (imageBytes != null) {
        imageUrl = await uploadTeacherImage(imageBytes);
      }

      Map<String, dynamic> teacherDataWithImage = {
        ...teacherData,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      // Update the teacher's data in the 'teachers' collection
      await _db.collection('teachers').doc(teacherId).update(teacherDataWithImage);

      // Update the user's display name in FirebaseAuth
      if (teacherData.containsKey('firstName') && teacherData.containsKey('lastName')) {
        String displayName = '${teacherData['firstName']} ${teacherData['lastName']}';
        QuerySnapshot usersSnapshot = await _db
            .collection('users')
            .where('role', isEqualTo: 'teacher')
            .get();
        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          if (userData['role'] == 'teacher' && userData['email'] == teacherData['email']) {
            String userId = userDoc.id;
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await user.updateDisplayName(displayName);
              await _db.collection('users').doc(userId).update({
                'firstName': teacherData['firstName'],
                'lastName': teacherData['lastName'],
              });
            }
          }
        }
      }
    } catch (e) {
      throw Exception('Error updating teacher data: $e');
    }
  }


  // Add service to delete teacher data
  Future<void> deleteTeacherData(String teacherId) async {
    try {
      // Delete the teacher document from the 'teachers' collection
      await _db.collection('teachers').doc(teacherId).delete();

      // Delete the teacher's data from the 'users' collection
      QuerySnapshot usersSnapshot = await _db
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .get();
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsValue(teacherId)) {
          await _db.collection('users').doc(userDoc.id).delete();
        }
      }
    } catch (e) {
      throw Exception('Error deleting teacher data: $e');
    }
  }
}
