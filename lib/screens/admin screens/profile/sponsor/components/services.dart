import 'package:cloud_firestore/cloud_firestore.dart';

class SponsorService {
  final CollectionReference sponsorsCollection =
  FirebaseFirestore.instance.collection('sponsors');

  Future<void> addSponsor({
    required String sponsorName,
    required String institution,
    required String address,
    required String telephone,
    required String email,
  }) async {
    try {
      Map<String, dynamic> sponsorData = {
        'sponsorName': sponsorName,
        'institution': institution,
        'address': address,
        'telephone': telephone,
        'email': email,
        'createdAt': Timestamp.now(),
      };

      await sponsorsCollection.add(sponsorData);
    } catch (e) {
      print('Error adding sponsor: $e');
    }
  }

  Stream<List<SponsorModel>> getSponsors() {
    return sponsorsCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SponsorModel.fromDocument(doc);
      }).toList();
    });
  }

  Future<void> updateSponsor({
    required String sponsorId,
    String? sponsorName,
    String? institution,
    String? address,
    String? telephone,
    String? email,
  }) async {
    try {
      Map<String, dynamic> updatedData = {};

      if (sponsorName != null) updatedData['sponsorName'] = sponsorName;
      if (institution != null) updatedData['institution'] = institution;
      if (address != null) updatedData['address'] = address;
      if (telephone != null) updatedData['telephone'] = telephone;
      if (email != null) updatedData['email'] = email;

      await sponsorsCollection.doc(sponsorId).update(updatedData);
    } catch (e) {
      print('Error updating sponsor: $e');
    }
  }

  Future<void> deleteSponsor(String sponsorId) async {
    try {
      await sponsorsCollection.doc(sponsorId).delete();
    } catch (e) {
      print('Error deleting sponsor: $e');
    }
  }
}


class SponsorModel {
  final String sponsorName;
  final String institution;
  final String address;
  final String telephone;
  final String email;

  SponsorModel({
    required this.sponsorName,
    required this.institution,
    required this.address,
    required this.telephone,
    required this.email,
  });

  factory SponsorModel.fromDocument(DocumentSnapshot doc) {
    return SponsorModel(
      sponsorName: doc['sponsorName'],
      institution: doc['institution'],
      address: doc['address'],
      telephone: doc['telephone'],
      email: doc['email'],
    );
  }
}
