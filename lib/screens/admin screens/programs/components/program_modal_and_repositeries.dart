
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'program_model.dart';

class ProgramModel extends Program {
  ProgramModel({
    required String id,
    required String name,
    required String institute,
    required String creditHour,
    required String description,
    required String preRequest,
    required String category,
    required String fee,
    required Color color,
  }) : super(
    id: id,
    name: name,
    institute: institute,
    creditHour: creditHour,
    description: description,
    preRequest: preRequest,
    category: category,
    fee: fee,
    color: color,
  );

  factory ProgramModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProgramModel(
      id: doc.id,
      name: data['name'] ?? 'No name',
      institute: data['institute'] ?? 'No institute',
      creditHour: data['creditHour'] ?? 'No credit hour',
      description: data['description'] ?? 'No description',
      preRequest: data['preRequest'] ?? 'No pre-request',
      fee: data['fee'] ?? 'no fee',
      category: data['category'] ?? 'No category',
      color: Color(int.parse(data['color'] ?? '0xFFFFFFFF')),
    );
  }
}

// data/repositories/program_repository.dart


abstract class ProgramRepository {
  Stream<List<Program>> getProgramsStream();
}

class ProgramRepositoryImpl implements ProgramRepository {
  final FirebaseFirestore firestore;

  ProgramRepositoryImpl(this.firestore);

  @override
  Stream<List<Program>> getProgramsStream() {
    return firestore.collection('programs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ProgramModel.fromFirestore(doc)).toList());
  }
}