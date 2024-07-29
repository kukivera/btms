import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDetail {
    final String? dob,
        email,
        firstName,
        middleName,
        lastName,
        name,
        phoneNumber,
        program,
        role,
        profilePic,
        companyName,
        instalment,
        position,
        secondaryphone,
        batch,
        section,
        qualification,
        id;
    final List<DocumentReference>? sections;

    TeacherDetail({
        this.dob,
        this.email,
        this.firstName,
        this.middleName,
        this.lastName,
        this.name,
        this.phoneNumber,
        this.program,
        this.role,
        this.profilePic,
        this.companyName,
        this.instalment,
        this.position,
        this.secondaryphone,
        this.batch,
        this.section,
        this.qualification,
        this.sections,
        this.id,
    });

    // Convert TeacherDetail object to a Map
    Map<String, dynamic> toMap() {
        return {
            'dob': dob,
            'email': email,
            'firstName': firstName,
            'middleName': middleName,
            'lastName': lastName,
            'name': name,
            'phoneNumber': phoneNumber,
            'program': program,
            'role': role,
            'profilePic': profilePic,
            'companyName': companyName,
            'instalment': instalment,
            'position': position,
            'secondaryphone': secondaryphone,
            'batch': batch,
            'section': section,
            'qualification': qualification,
            'sections': sections?.map((ref) => ref.path).toList(),
            'id': id,
        };
    }

    factory TeacherDetail.fromFirestore(DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TeacherDetail(
            dob: data['dob'],
            email: data['email'],
            firstName: data['firstName'],
            middleName: data['middleName'],
            lastName: data['lastName'],
            name: data['name'],
            phoneNumber: data['phoneNumber'],
            program: data['program'],
            role: data['role'],
            profilePic: data['profilePic'],
            companyName: data['companyName'],
            instalment: data['instalment'],
            position: data['position'],
            secondaryphone: data['secondaryphone'],
            batch: data['batch'],
            section: data['section'],
            qualification: data['qualification'],
            sections: (data['sections'] as List<dynamic>?)
                ?.map((section) => FirebaseFirestore.instance.doc(section))
                .toList(),
            id: doc.id,
        );
    }
}
