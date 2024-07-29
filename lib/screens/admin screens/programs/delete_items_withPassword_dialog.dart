import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
  DeleteConfirmationDialogState createState() => DeleteConfirmationDialogState();
}

class DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
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
              decoration: const InputDecoration(labelText: 'Password'),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
