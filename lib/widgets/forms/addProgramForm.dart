import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';



class ProgramForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) onProgramAdded;

  const ProgramForm({
    super.key,
    required this.formKey,
    required this.onProgramAdded,
  });

  @override
  _ProgramFormState createState() => _ProgramFormState();
}

class _ProgramFormState extends State<ProgramForm> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.blue, // Border color
          ),
        ),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormField(
                labelText: 'Program Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter program name';
                  }
                  return null;
                },
              ),
              _buildFormField(
                labelText: 'Program Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter program description';
                  }
                  return null;
                },
              ),
              _buildFormField(
                labelText: 'Credit Hour',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credit hour';
                  }
                  return null;
                },
              ),
              _buildFormField(
                labelText: 'Type of Program',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter type of program';
                  }
                  return null;
                },
              ),
              _buildFormField(
                labelText: 'Institute',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter institute';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.formKey.currentState!.validate()) {
                      // Add program functionality here
                      widget.onProgramAdded('Program Added!'); // Pass any data back if needed
                      Navigator.pop(context); // Close the form
                    }
                  },
                  child: Text('Add Program'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                  ),
                ),
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black), // Text color
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Border color
          ),
        ),
        validator: validator,
      ),
    );
  }
}