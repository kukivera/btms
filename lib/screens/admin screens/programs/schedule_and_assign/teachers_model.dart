

import 'package:cloud_firestore/cloud_firestore.dart';

class Teachers {
  final String? dob, email, firstName, lastName, name, phoneNumber, program, role, imageUrl,companyName,instalment, position, secondaryphone,batch,section,qualification,id;

  Teachers(
      {this.dob,
        this.firstName,
        this.lastName,
        this.position,
        this.companyName,
        this.instalment,
        this.secondaryphone,
        this.batch,
        this.section,
        this.qualification,
        this.name,
        this.email,
        this.phoneNumber,
        this.program,
        this.role,
        this.imageUrl,
        this.id});

  factory Teachers.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Teachers(
      dob: data?['dob'],
      email: data?['email'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      position: data?['position'],
      companyName: data?['companyName'],
      instalment: data?['instalment'],
      secondaryphone: data?['secondaryphone'],
      batch: data?['batch'],
      section: data?['section'],
      qualification: data?['qualification'],
      name: data?['name'],
      phoneNumber: data?['phoneNumber'],
      program: data?['program'],
      role: data?['role'],
      imageUrl: data?['imageUrl'],
      id:  snapshot.id,
    );
  }
}

Future<List<Teachers>> fetchTeachers() async {
  List<Teachers> teachersList = [];

  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .get();

    teachersList = snapshot.docs.map((doc) => Teachers.fromDocument(doc)).toList();
  } catch (e) {
    // Handle error
    print('Error fetching teachers: $e');
  }

  return teachersList;
}