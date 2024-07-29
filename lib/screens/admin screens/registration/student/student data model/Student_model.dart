import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
    final String? dob,
        email,
        firstName,
        middleName, // Added middleName field
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
        sponsor,
        id;
    final List<DocumentReference>? sections;

    Students({
        this.dob,
        this.email,
        this.firstName,
        this.middleName, // Added middleName to constructor
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
        this.sections,
        this.sponsor,
        this.id,
    });

    // Convert Student object to a Map
    Map<String, dynamic> toMap() {
        return {
            'dob': dob,
            'email': email,
            'firstName': firstName,
            'middleName': middleName, // Added middleName to map
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
            'sections': sections?.map((ref) => ref.path).toList(),
            'sponsor': sponsor,
            'id': id,
        };
    }

    factory Students.fromFirestore(DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Students(
            dob: data['dob'],
            email: data['email'],
            firstName: data['firstName'],
            middleName: data['middleName'], // Added middleName to factory constructor
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
            sections: (data['sections'] as List<dynamic>?)
                ?.map((section) => FirebaseFirestore.instance.doc(section))
                .toList(),
            sponsor: data['sponsor'],
            id: doc.id,
        );
    }
}
