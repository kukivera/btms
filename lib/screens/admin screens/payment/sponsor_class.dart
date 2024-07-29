import 'package:cloud_firestore/cloud_firestore.dart';

class Sponsor {
  final String id;
  final String sponsorName;
  final String address;
  final String email;
  final String institution;
  final String telephone;
  final Timestamp createdAt;

  Sponsor({
    required this.id,
    required this.sponsorName,
    required this.address,
    required this.email,
    required this.institution,
    required this.telephone,
    required this.createdAt,
  });

  factory Sponsor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Sponsor(
      id: doc.id,
      sponsorName: data['sponsorName'],
      address: data['address'],
      email: data['email'],
      institution: data['institution'],
      telephone: data['telephone'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sponsorName': sponsorName,
      'address': address,
      'email': email,
      'institution': institution,
      'telephone': telephone,
      'createdAt': createdAt,
    };
  }
}
