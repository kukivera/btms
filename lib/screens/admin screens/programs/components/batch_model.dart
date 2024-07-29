import 'package:cloud_firestore/cloud_firestore.dart';


class Batch {
  final String id;
  final String programId;
  final int year;
  final List<DocumentReference> documents;

  Batch({
    required this.id,
    required this.programId,
    required this.year,
    required this.documents,
  });

  factory Batch.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Batch(
      id: doc.id,
      programId: data['programId'],
      year: data['year'],
      documents: List<DocumentReference>.from(data['documents']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'programId': programId,
      'year': year,
      'documents': documents.map((ref) => ref.path).toList(),
    };
  }
}