import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference venuesCollection =
FirebaseFirestore.instance.collection('venues');


class VenueService {

    Future<void> addVenue({
    required String venueName,
    required String url,
    required String address,
    required String telephone,
    required String number_of_seat,
  }) async {
    try {
      await venuesCollection.add({
        'venueName': venueName,
        'url': url,
        'address': address,
        'telephone': telephone,
        'number_of_seat': number_of_seat,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error adding course: $e');
    }
  }


  Stream<List<VenueModel>> getVenues() {
    return venuesCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return VenueModel.fromDocument(doc);
      }).toList();
    });
  }
    Future<void> deleteVenue(String venueName) async {
      try {
        var snapshot = await venuesCollection.where('venueName', isEqualTo: venueName).get();
        for (var doc in snapshot.docs) {
          await venuesCollection.doc(doc.id).delete();
        }
      } catch (e) {
        print('Error deleting venue: $e');
      }
    }

    Future<void> updateVenue(
        String venueName, String name, String url, String address, String telephone, String seats) async {
      try {
        var snapshot = await venuesCollection.where('venueName', isEqualTo: venueName).get();
        for (var doc in snapshot.docs) {
          await venuesCollection.doc(doc.id).update({
            'venueName': name,
            'url': url,
            'address': address,
            'telephone': telephone,
            'number_of_seat': seats,
          });
        }
      } catch (e) {
        print('Error updating venue: $e');
      }
    }







}

class VenueModel {
  final String venueName;
  final String url;
  final String address;
  final String telephone;
  final String number_of_seat;

  VenueModel({
    required this.venueName,
    required this.url,
    required this.address,
    required this.telephone,
    required this.number_of_seat,
  });

  factory VenueModel.fromDocument(DocumentSnapshot doc) {
    return VenueModel(
      venueName: doc['venueName'],
      url: doc['url'],
      address: doc['address'],
      telephone: doc['telephone'],
      number_of_seat: doc['number_of_seat'],
    );
  }
}
