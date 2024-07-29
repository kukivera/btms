import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';

import '../student data model/Student_model.dart';
import '../student registation/services.dart';




class StudentProfileScreen extends StatefulWidget {
  final Students student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController middleNameController; // Added middleNameController
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController dobController;
  late TextEditingController secondaryPhoneController;
  late TextEditingController companyNameController;
  late TextEditingController positionController;
  late TextEditingController programController;
  late TextEditingController sponsorController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.student.firstName);
    lastNameController = TextEditingController(text: widget.student.lastName);
    middleNameController = TextEditingController(text: widget.student.middleName); // Initialize middleNameController
    emailController = TextEditingController(text: widget.student.email);
    phoneNumberController =
        TextEditingController(text: widget.student.phoneNumber);
    dobController = TextEditingController(text: widget.student.dob);
    secondaryPhoneController =
        TextEditingController(text: widget.student.secondaryphone);
    companyNameController =
        TextEditingController(text: widget.student.companyName);
    positionController = TextEditingController(text: widget.student.position);
    programController = TextEditingController(text: widget.student.program);
    sponsorController = TextEditingController(text: widget.student.sponsor);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose(); // Dispose of middleNameController
    emailController.dispose();
    phoneNumberController.dispose();
    dobController.dispose();
    secondaryPhoneController.dispose();
    companyNameController.dispose();
    positionController.dispose();
    programController.dispose();
    sponsorController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      Map<String, dynamic> updatedData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'middleName': middleNameController.text, // Include middleName in updatedData
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'dob': dobController.text,
        'secondaryPhone': secondaryPhoneController.text,
        'companyName': companyNameController.text,
        'position': positionController.text,
        'program': programController.text,
        'sponsor': sponsorController.text,
      };

      // Ensure the student ID is not null
      final studentId = widget.student.id;
      if (studentId == null) {
        throw Exception('Student ID is null');
      }

      await _firebaseService.updateStudentData(studentId, updatedData, null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating student profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile of ${widget.student.firstName} ${widget.student.lastName}'),
        backgroundColor: Colors.blue, // Replace with your primaryColor
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 1000,
            height: 600,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 555,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Replace with your secondaryColor
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          NetworkImage(widget.student.profilePic ?? ''),
                        ),
                        SizedBox(height: 20),
                        ProfileTextField(
                          controller: firstNameController,
                          title: 'First Name',
                        ),
                        SizedBox(height: 15),
                        ProfileTextField(
                          controller: lastNameController,
                          title: 'Last Name',
                        ),
                        SizedBox(height: 15),
                        ProfileTextField(
                          controller: middleNameController,
                          title: 'Middle Name',
                        ),
                        SizedBox(height: 15),
                        ProfileTextField(
                          controller: emailController,
                          title: 'Email',
                        ),
                        SizedBox(height: 15),
                        ProfileTextField(
                          controller: phoneNumberController,
                          title: 'Phone Number',
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Replace with your secondaryColor
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            ProfileTextField(
                              controller: dobController,
                              title: 'Date of Birth',
                            ),
                            SizedBox(height: 15),
                            ProfileTextField(
                              controller: secondaryPhoneController,
                              title: 'Secondary Phone',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 300,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Replace with your secondaryColor
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            ProfileTextField(
                              controller: companyNameController,
                              title: 'Company Name',
                            ),
                            SizedBox(height: 15),
                            ProfileTextField(
                              controller: positionController,
                              title: 'Position',
                            ),
                            SizedBox(height: 15),
                            ProfileTextField(
                              controller: programController,
                              title: 'Program',
                            ),
                            SizedBox(height: 15),
                            ProfileTextField(
                              controller: sponsorController,
                              title: 'Sponsor',
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.controller,
    required this.title,
  });

  final TextEditingController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          hintText: title,
          hintStyle: const TextStyle(color: primaryColor, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
