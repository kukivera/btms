import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
class Program {
  final String id;
  final String name;
  final String institute;
  final String creditHour;
  final String description;
  final String preRequest;
  final String category;
  final String fee;
  final Color color;

  Program({
    required this.id,
    required this.name,
    required this.institute,
    required this.creditHour,
    required this.description,
    required this.preRequest,
    required this.category,
    required this.fee,
    required this.color,
  });

  Program copyWith({
    String? id,
    String? name,
    String? institute,
    String? creditHour,
    String? description,
    String? preRequest,
    String? category,
    String? fee,
    Color? color,
  }) {
    return Program(
      id: id ?? this.id,
      name: name ?? this.name,
      institute: institute ?? this.institute,
      creditHour: creditHour ?? this.creditHour,
      description: description ?? this.description,
      preRequest: preRequest ?? this.preRequest,
      category: category ?? this.category,
      fee: fee ?? this.fee,
      color: color ?? this.color,
    );
  }

  factory Program.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to load program data');
    }
    return Program(
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

abstract class ProgramRepository {
  Stream<List<Program>> getProgramsStream();
}

class ProgramRepositoryImpl implements ProgramRepository {
  final FirebaseFirestore firestore;

  ProgramRepositoryImpl(this.firestore);

  @override
  Stream<List<Program>> getProgramsStream() {
    return firestore.collection('programs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Program.fromFirestore(doc)).toList());
  }
}