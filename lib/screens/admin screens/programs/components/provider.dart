import 'package:bruh_finance_tms/screens/admin%20screens/programs/components/updateDeleteDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'program_model.dart';
import 'batch_model.dart';
import 'sectionModel.dart';
import 'fetchAndOtherProgram.dart';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';





class ProgramProvider with ChangeNotifier {
  final FetchPrograms fetchPrograms;
  List<Program> programs = [];
  bool isLoading = true;
  String? errorMessage;

  ProgramProvider(this.fetchPrograms) {
    loadPrograms();
  }

  void loadPrograms() {
    fetchPrograms.execute().listen(
          (programs) {
        this.programs = programs;
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        errorMessage = error.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }



  Future<void> updateProgram(Program updatedProgram) async {
    try {
      // Update the program in Firestore
      await FirebaseFirestore.instance
          .collection('programs')
          .doc(updatedProgram.id)
          .update({
        'name': updatedProgram.name,
        'institute': updatedProgram.institute,
        'creditHour': updatedProgram.creditHour,
        'description': updatedProgram.description,
        'preRequest': updatedProgram.preRequest,
        'category': updatedProgram.category,
        'fee': updatedProgram.fee,
        'color': updatedProgram.color.value.toString(),
      });

      // Update the local list of programs
      int index = programs.indexWhere((program) =>
      program.id == updatedProgram.id);
      if (index != -1) {
        programs[index] = updatedProgram;
        notifyListeners();
      }
      print('Program successfully updated');
    } catch (error) {
      print('Error updating program: $error');
      errorMessage = error.toString();
      notifyListeners();
    }
  }
}

  class BatchProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  List<Batch> _batches = [];
  bool batchIsLoading = true;
  String? _errorMessage;

  BatchProvider(this._firestore);

  List<Batch> get batches => _batches;
  bool get isLoading => batchIsLoading;
  String? get errorMessage => _errorMessage;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Batch>> fetchBatchesStream(String programId) {
    return _firestore
        .collection('batches')
        .where('programId', isEqualTo: programId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Batch.fromFirestore(doc)).toList());
  }

  Future<List<Batch>> getBatchesByProgramId(String programId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('batches')
          .where('programId', isEqualTo: programId)
          .get();

      List<Batch> batches = querySnapshot.docs
          .map((doc) => Batch.fromFirestore(doc))
          .toList();

      return batches;
    } catch (error) {
      print('Error fetching batches: $error');
      rethrow;
    }
  }

  Future<void> deleteBatch(String programId, String batchId) async {
    try {
      await _firestore.collection('batches').doc(batchId).delete();
    } catch (e) {
      _errorMessage = 'Error deleting batch: $e';
      notifyListeners();
    }
  }

  Future<void> uploadFile(String batchId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;

        UploadTask uploadTask = _storage
            .ref('resources/${file.name}')
            .putBlob(html.Blob([file.bytes]));

        await uploadTask.whenComplete(() async {
          String fileURL = await uploadTask.snapshot.ref.getDownloadURL();

          DocumentReference newDocRef = await _firestore
              .collection('resources')
              .add({'url': fileURL, 'name': file.name});

          await _firestore.collection('batches').doc(batchId).update({
            'documents': FieldValue.arrayUnion([newDocRef]),
          });

          notifyListeners();
        });
      } else {
        throw Exception('No file selected');
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<List<DocumentSnapshot>> getDocumentsForBatch(String batchId) async {
    try {
      DocumentSnapshot batchDoc =
      await _firestore.collection('batches').doc(batchId).get();

      if (!batchDoc.exists) {
        throw 'Batch with ID $batchId does not exist';
      }

      Map<String, dynamic>? data = batchDoc.data() as Map<String, dynamic>?;

      List<DocumentReference> documentsRefs = (data?['documents'] as List)
          .whereType<DocumentReference>()
          .toList();

      if (documentsRefs.isEmpty) {
        return [];
      }

      List<DocumentSnapshot> documentSnapshots = await Future.wait(
        documentsRefs.map((docRef) => docRef.get()).toList(),
      );

      return documentSnapshots;
    } catch (e) {
      print('Error fetching documents for batch: $e');
      rethrow;
    }
  }

  Future<String?> getDocumentDownloadURL(String batchId, String documentName) async {
    try {
      DocumentSnapshot batchDoc = await _firestore.collection('batches').doc(batchId).get();

      if (!batchDoc.exists) {
        throw Exception('Batch with ID $batchId does not exist');
      }

      List<DocumentReference> documents = (batchDoc.data() as Map<String, dynamic>)['documents']
          .whereType<DocumentReference>()
          .toList();

      for (DocumentReference docRef in documents) {
        DocumentSnapshot docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
          if (docData['name'] == documentName) {
            return docData['url'];
          }
        }
      }

      throw Exception('Document $documentName does not exist in batch $batchId');
    } catch (e) {
      print('Error fetching download URL: $e');
      throw Exception('Failed to fetch download URL');
    }
  }

  Future<void> downloadDocument(String batchId, String documentName) async {
    try {
      String? fileURL = await getDocumentDownloadURL(batchId, documentName);

      if (fileURL != null) {
        final html.AnchorElement anchor = html.AnchorElement(href: fileURL)
          ..setAttribute("download", documentName)
          ..click();
      } else {
        throw Exception('Failed to fetch download URL');
      }
    } catch (e) {
      print('Error fetching download URL: $e');
      throw Exception('Failed to fetch download URL');
    }
  }

  Future<void> deleteDocument(String batchId, String documentName) async {
    try {
      DocumentSnapshot batchDoc = await _firestore.collection('batches').doc(batchId).get();

      if (batchDoc.exists) {
        Map<String, dynamic>? data = batchDoc.data() as Map<String, dynamic>?;
        List<dynamic> documents = data?['documents'] ?? [];

        // Find the document with the matching name
        var documentData = await _findDocument(documents, documentName);

        if (documentData != null) {
          String fileName;
          if (documentData is DocumentReference) {
            // Get the document snapshot to retrieve the file name
            DocumentSnapshot docSnapshot = await documentData.get();
            fileName = docSnapshot['name'];
          } else {
            fileName = documentData['name'];
          }

          // Delete file from Firebase Storage
          await _storage.ref('resources/$fileName').delete();

          // Delete file information from Firestore
          await _firestore.collection('batches').doc(batchId).update({
            'documents': FieldValue.arrayRemove([documentData])
          });

          notifyListeners();
        } else {
          throw Exception('Document $documentName does not exist in batch $batchId');
        }
      } else {
        throw Exception('Batch with ID $batchId does not exist');
      }
    } catch (e) {
      print('Error deleting document: $e');
      throw Exception('Failed to delete document');
    }
  }

  Future<dynamic> _findDocument(List<dynamic> documents, String documentName) async {
    // Search for the document with the matching name
    for (var doc in documents) {
      if (doc is DocumentReference) {
        // Handle asynchronous comparison using async/await
        bool isEqual = await _compareDocumentReference(doc, documentName);
        if (isEqual) {
          return doc;
        }
      } else if (doc is Map<String, dynamic>) {
        // Directly compare if it's a Map
        if (doc['name'] == documentName) {
          return doc;
        }
      }
    }
    return null;
  }

  // Helper method to compare DocumentReference asynchronously
  Future<bool> _compareDocumentReference(DocumentReference docRef, String documentName) async {
    DocumentSnapshot docSnapshot = await docRef.get();
    return docSnapshot['name'] == documentName;
  }



}



class SectionProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool sectionIsLoading = false;
  String? errorMessage;
  List<Section> sections = [];

  SectionProvider(FirebaseFirestore instance);

  Future<List<Section>> getSectionsByBatchId(String programId, String batchId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sections')
          .where('programId', isEqualTo: programId)
          .where('batchId', isEqualTo: batchId)
          .get();

      List<Section> sections = querySnapshot.docs
          .map((doc) => Section.fromFirestore(doc))
          .toList();

      return sections;
    } catch (error) {
      print('Error fetching sections: $error');
      rethrow;
    }
  }

  Stream<List<Section>> fetchSectionsStream(String programId, String batchId) {
    return _firestore
        .collection('sections')
        .where('programId', isEqualTo: programId)
        .where('batchId', isEqualTo: batchId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Section.fromFirestore(doc)).toList());
  }

  Future<void> deleteSection(String programId, String batchId,
      String sectionId) async {
    try {
      await _firestore
          .collection('sections')
          .doc(sectionId)
          .delete();
    } catch (e) {
      errorMessage = 'Error deleting section: $e';
      notifyListeners();
    }
  }


}