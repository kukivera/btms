import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../teacher data model/teachers_model.dart';


class EditTeacherDialog extends StatefulWidget {
  final TeacherDetail teacher;
  final Function onUpdate;

  const EditTeacherDialog({required this.teacher, required this.onUpdate, Key? key}) : super(key: key);

  @override
  _EditTeacherDialogState createState() => _EditTeacherDialogState();
}

class _EditTeacherDialogState extends State<EditTeacherDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _secondNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _companyNameController;
  late TextEditingController _positionController;
  late TextEditingController _secondaryPhoneController;
  late TextEditingController _batchController;
  late TextEditingController _sectionController;
  late TextEditingController _qualificationController;
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.teacher.firstName);
    _secondNameController = TextEditingController(text: widget.teacher.section);
    _middleNameController = TextEditingController(text: widget.teacher.middleName);
    _lastNameController = TextEditingController(text: widget.teacher.lastName);
    _nameController = TextEditingController(text: widget.teacher.name);
    _emailController = TextEditingController(text: widget.teacher.email);
    _phoneNumberController = TextEditingController(text: widget.teacher.phoneNumber);
    _companyNameController = TextEditingController(text: widget.teacher.companyName);
    _positionController = TextEditingController(text: widget.teacher.position);
    _secondaryPhoneController = TextEditingController(text: widget.teacher.secondaryphone);
    _batchController = TextEditingController(text: widget.teacher.batch);
    _sectionController = TextEditingController(text: widget.teacher.section);
    _qualificationController = TextEditingController(text: widget.teacher.id);
    _selectedDob = widget.teacher.dob != null ? DateFormat('dd/MM/yyyy').parse(widget.teacher.dob!) : null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _companyNameController.dispose();
    _positionController.dispose();
    _secondaryPhoneController.dispose();
    _batchController.dispose();
    _sectionController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    // Update the teacher details in Firestore
    final updatedTeacher = TeacherDetail(
      id: widget.teacher.id,
      firstName: _firstNameController.text,
      middleName: _middleNameController.text,
      lastName: _lastNameController.text,
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      companyName: _companyNameController.text,
      position: _positionController.text,
      secondaryphone: _secondaryPhoneController.text,
      batch: _batchController.text,
      section: _sectionController.text,
      qualification: _qualificationController.text,
      dob: _selectedDob != null ? DateFormat('dd/MM/yyyy').format(_selectedDob!) : null,
    );

    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.teacher.id)
        .update(updatedTeacher.toMap());

    widget.onUpdate();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Teacher'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _middleNameController,
              decoration: const InputDecoration(labelText: 'Middle Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _companyNameController,
              decoration: const InputDecoration(labelText: 'Company Name'),
            ),
            TextField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            TextField(
              controller: _secondaryPhoneController,
              decoration: const InputDecoration(labelText: 'Secondary Phone'),
            ),
            TextField(
              controller: _batchController,
              decoration: const InputDecoration(labelText: 'Batch'),
            ),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
            TextField(
              controller: _qualificationController,
              decoration: const InputDecoration(labelText: 'Qualification'),
            ),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDob != null ? DateFormat('dd/MM/yyyy').format(_selectedDob!) : 'Select Date',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
