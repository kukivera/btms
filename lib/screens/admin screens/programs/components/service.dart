import 'package:cloud_firestore/cloud_firestore.dart';
import 'program_model.dart';
import 'batch_model.dart';
import 'sectionModel.dart';

class ProgramService {
  final CollectionReference programCollection =
  FirebaseFirestore.instance.collection('programs');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteProgram(String programId) async {
    try {
      await _firestore.collection('programs').doc(programId).delete();
      print('Program deleted successfully');
    } catch (e) {
      print('Error deleting program: $e');
    }
  }


  Future<void> addProgram(Program program) async {
    await programCollection.add({
      'name': program.name,
      'institute': program.institute,
      'creditHour': program.creditHour,
      'description': program.description,
      'preRequest': program.preRequest,
      'category': program.category,
      'color': program.color.value.toString(),
    });
  }

}
