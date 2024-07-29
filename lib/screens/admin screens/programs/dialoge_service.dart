import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/addProgramDialog.dart';
import 'components/program_model.dart';
import 'components/batch_model.dart';
import 'components/updateDeleteDialog.dart';
import 'components/sectionModel.dart';



// executing update delete and add program dialog
class DialogService {
  static Future<void> showAddSectionDialog(BuildContext context, String programId, String batchId) async {
    String sectionName = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Section'),
          content: TextField(
            onChanged: (value) {
              sectionName = value;
            },
            decoration: const InputDecoration(hintText: "Section Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (sectionName.isNotEmpty) {
                  FirebaseFirestore.instance.collection('sections').add({
                    'programId': programId,
                    'batchId': batchId,
                    'name': sectionName,
                    'students': [],
                    'courses': [],
                    'status': 'ongoing',
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  static void showAddBatchDialog(BuildContext context, String programId) {
    final _formKey = GlobalKey<FormState>();
    int? year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Batch'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a year';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    year = int.tryParse(value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Add the new batch to Firestore
                  final newBatchRef = FirebaseFirestore.instance.collection('batches').doc();
                  final newBatch = Batch(
                    id: newBatchRef.id,
                    programId: programId,
                    year: year!,
                    documents: [],
                  );

                  await newBatchRef.set(newBatch.toMap());

                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  static void showAddProgramDialog(BuildContext context, Function(Program) onAddProgram) {
    showDialog(
      context: context,
      builder: (context) => AddProgramDialog(onProgramAdded: onAddProgram),
    );
  }

  static void showUpdateProgramDialog(BuildContext context, Program program, Function(Program) onUpdateProgram) {
    showDialog(
      context: context,
      builder: (context) => UpdateProgramDialog(program: program, onProgramUpdated: onUpdateProgram),
    );
  }



  static void showDeleteConfirmationDialog({
    required BuildContext context,
    required String itemId,
    required String title,
    required Future<void> Function(String itemId) deleteFunction,
  }) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        itemId: itemId,
        title: title,
        deleteFunction: deleteFunction,
      ),
    );
  }



}

class DeleteConfirmationDialog extends StatefulWidget {
  final String itemId;
  final Future<void> Function(String itemId) deleteFunction;
  final String title;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemId,
    required this.deleteFunction,
    required this.title,
  });

  @override
  _DeleteConfirmationDialogState createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  final _formKey = GlobalKey<FormState>();
  String password = '';
  String? errorMessage;

  Future<void> _reauthenticateAndDelete() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          errorMessage = 'No user is currently signed in.';
        });
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await widget.deleteFunction(widget.itemId);
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      setState(() {
        errorMessage = 'Error authenticating: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please re-enter your password to confirm.'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _reauthenticateAndDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }

}
