
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../constants.dart';
import '../student registation/services.dart';
import '../student data model/Student_model.dart';
import '../student profile/student_profile.dart';


class StudentTable extends StatefulWidget {
  final List<Students>? filteredStudents;
  final Function onDelete;
  final Function onUpdate; // Added callback function for updating the table

  const StudentTable({super.key, this.filteredStudents, required this.onDelete, required this.onUpdate});

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isDeleting = false;

  List<String> programs = [];
  List<String> sponsors = [];
  String? selectedProgram;
  String? selectedSponsor;

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: const Text('Are you sure you want to delete this student? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Future<void> _deleteStudent(String studentId) async {
    final confirmed = await _showDeleteConfirmationDialog();
    if (!confirmed) return;

    try {
      setState(() {
        _isDeleting = true;
      });
      await FirebaseFirestore.instance.collection('students').doc(studentId).delete();
      widget.onDelete();
    } catch (e) {
      print('Error deleting student: $e');
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  Future<void> _editStudent(Students student) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditStudentDialog(student: student);
      },
    );

    if (result != null && result is Students) {
      // Show success message and reload the table
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully')),
      );
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = widget.filteredStudents ?? [];

    return SizedBox(
      width: 800,
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
          decoration: const BoxDecoration(),
          dataRowColor: MaterialStateProperty.all(primaryColor),
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          headingRowDecoration: kMediumBoxDecoration,
          dividerThickness: 4,
          checkboxAlignment: Alignment.center,
          columns: [
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: const Text("Name", style: kMediumColoredTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: const Text("Program", style: kMediumColoredTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: const Text("Delete", style: kMediumColoredTextStyle),
              ),
            ),
            DataColumn2(
              label: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: const Text("Edit", style: kMediumColoredTextStyle),
              ),
            ),
          ],
          rows: students.asMap().entries.map(
                (entry) {
              int index = entry.key;
              Students student = entry.value;
              return DataRow2(
                decoration: kMediumBoxDecoration.copyWith(
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 3.0,
                    ),
                  ],
                ),
                cells: [
                  DataCell(
                    Row(
                      children: [
                        if (student.profilePic != null)
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(student.profilePic!) as ImageProvider<Object>?,
                          ),
                        if (student.profilePic == null)
                          const CircleAvatar(
                            radius: 10,
                            child: Icon(Icons.person),
                          ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentProfileScreen(
                                  student: student,
                                ),
                              ),
                            );
                          },
                          child: Text(student.name ?? '',
                              style: kMediumColoredTextStyle),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(student.program ?? '', style: kMediumColoredTextStyle),
                  ),
                  DataCell(
                    _isDeleting
                        ? const CircularProgressIndicator()
                        : IconButton(
                      icon: const Icon(Icons.delete, color: primaryColor),
                      onPressed: student.id != null
                          ? () => _deleteStudent(student.id!)
                          : null,
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: primaryColor),
                      onPressed: () => _editStudent(student),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class EditStudentDialog extends StatefulWidget {
  final Students student;

  const EditStudentDialog({super.key, required this.student});

  @override
  _EditStudentDialogState createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _roleController;
  late TextEditingController _profilePicController;
  late TextEditingController _companyNameController;
  late TextEditingController _instalmentController;
  late TextEditingController _positionController;
  late TextEditingController _secondaryphoneController;
  late TextEditingController _batchController;
  late TextEditingController _sponsorController;
  late TextEditingController _idController;

  String? selectedProgram;
  List<String> programs = [];
  List<String> sponsors = [];
  String? selectedSponsor;
  final FirebaseService _firebaseService = FirebaseService();

  Uint8List? _profileImage;

  @override
  void initState() {
    super.initState();

    _fetchPrograms();
    _fetchSponsors();
    _dobController = TextEditingController(text: widget.student.dob);
    _emailController = TextEditingController(text: widget.student.email);
    _firstNameController = TextEditingController(text: widget.student.firstName);
    _middleNameController = TextEditingController(text: widget.student.middleName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _nameController = TextEditingController(text: widget.student.name);
    _phoneNumberController = TextEditingController(text: widget.student.phoneNumber);
    _roleController = TextEditingController(text: widget.student.role);
    _profilePicController = TextEditingController(text: widget.student.profilePic);
    _companyNameController = TextEditingController(text: widget.student.companyName);
    _instalmentController = TextEditingController(text: widget.student.instalment);
    _positionController = TextEditingController(text: widget.student.position);
    _secondaryphoneController = TextEditingController(text: widget.student.secondaryphone);
    _batchController = TextEditingController(text: widget.student.batch);
    _sponsorController = TextEditingController(text: widget.student.sponsor);
    _idController = TextEditingController(text: widget.student.id);

    selectedProgram = widget.student.program;
  }

  Future<void> _fetchSponsors() async {
    try {
      List<String> fetchedSponsors = await _firebaseService.fetchSponsors();
      setState(() {
        sponsors = fetchedSponsors;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load sponsors')),
      );
    }
  }

  Future<void> _fetchPrograms() async {
    try {
      List<String> fetchedPrograms = await _firebaseService.fetchPrograms();
      setState(() {
        programs = fetchedPrograms;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load programs')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = await pickedFile.readAsBytes();
    }
  }

  Future<void> updateUserAndStudent(Students updatedStudent) async {
    try {
      // Update document in the student collection
      await FirebaseFirestore.instance
          .collection('students')
          .doc(updatedStudent.id)
          .update(updatedStudent.toMap());

      // Update document in the user collection (assuming the user ID is the same as the student ID)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedStudent.id)
          .update(updatedStudent.toMap());

      print('User and student updated successfully');
    } catch (e) {
      print('Error updating user and student: $e');
      throw e;
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _roleController.dispose();
    _profilePicController.dispose();
    _companyNameController.dispose();
    _instalmentController.dispose();
    _positionController.dispose();
    _secondaryphoneController.dispose();
    _batchController.dispose();
    _sponsorController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Widget _buildProgramDropdown() {
    return SizedBox(
      height: 50,
      width: 350,
      child: DropdownButtonFormField<String>(
        value: selectedProgram,
        onChanged: (String? newValue) {
          setState(() {
            selectedProgram = newValue;
          });
        },
        items: programs.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          hintText: 'Program',
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value == null ? 'This field is required' : null,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSponsorDropdown() {
    return SizedBox(
      height: 50,
      width: 350,
      child: DropdownButtonFormField<String>(
        value: selectedSponsor,
        onChanged: (String? newValue) {
          setState(() {
            selectedSponsor = newValue;
          });
        },
        items: [
          const DropdownMenuItem<String>(
            value: 'Self Sponsor',
            child: Text('Self Sponsor'),
          ),
          ...sponsors.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          hintText: 'Sponsor',
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value == null ? 'This field is required' : null,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  await pickImage();
                  setState(() {}); // To update the UI after picking the image
                },
                child: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  radius: 50,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : CircleAvatar(
                    radius: 48,
                    backgroundImage: MemoryImage(_profileImage!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Student',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                    TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
                    TextField(controller: _middleNameController, decoration: const InputDecoration(labelText: 'Middle Name')),
                    TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                    TextField(controller: _phoneNumberController, decoration: const InputDecoration(labelText: 'Phone Number')),
                    _buildProgramDropdown(), // Dropdown for program
                    TextField(controller: _roleController, decoration: const InputDecoration(labelText: 'Role')),
                    TextField(controller: _profilePicController, decoration: const InputDecoration(labelText: 'Profile Pic URL')),
                    TextField(controller: _companyNameController, decoration: const InputDecoration(labelText: 'Company Name')),
                    TextField(controller: _instalmentController, decoration: const InputDecoration(labelText: 'Instalment')),
                    TextField(controller: _positionController, decoration: const InputDecoration(labelText: 'Position')),
                    TextField(controller: _secondaryphoneController, decoration: const InputDecoration(labelText: 'Secondary Phone')),
                    TextField(controller: _batchController, decoration: const InputDecoration(labelText: 'Batch')),
                    _buildSponsorDropdown(), // Dropdown for sponsor
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final updatedStudent = Students(
                        dob: _dobController.text,
                        email: _emailController.text,
                        firstName: _firstNameController.text,
                        middleName: _middleNameController.text,
                        lastName: _lastNameController.text,
                        name: _nameController.text,
                        phoneNumber: _phoneNumberController.text,
                        program: selectedProgram,
                        role: _roleController.text,
                        profilePic: _profilePicController.text,
                        companyName: _companyNameController.text,
                        instalment: _instalmentController.text,
                        position: _positionController.text,
                        secondaryphone: _secondaryphoneController.text,
                        batch: _batchController.text,
                        sponsor: selectedSponsor,
                        id: _idController.text,
                      );
                      updateUserAndStudent(updatedStudent);
                      Navigator.pop(context, updatedStudent);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
