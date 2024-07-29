import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';
import '../teacher data model/teachers_model.dart';
import '../teacher registartion/teachers_registration_services.dart';

class TeacherProfileScreen extends StatefulWidget {
  final TeacherDetail teacher;

  const TeacherProfileScreen({Key? key, required this.teacher})
      : super(key: key);

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final TeacherFirebaseService _firebaseService = TeacherFirebaseService();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
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

    firstNameController = TextEditingController(text: widget.teacher.firstName);
    lastNameController = TextEditingController(text: widget.teacher.lastName);
    emailController = TextEditingController(text: widget.teacher.email);
    phoneNumberController =
        TextEditingController(text: widget.teacher.phoneNumber);
    dobController = TextEditingController(text: widget.teacher.dob);
    secondaryPhoneController =
        TextEditingController(text: widget.teacher.secondaryphone);
    companyNameController =
        TextEditingController(text: widget.teacher.companyName);
    positionController = TextEditingController(text: widget.teacher.position);
    programController = TextEditingController(text: widget.teacher.program);
    sponsorController = TextEditingController(text: widget.teacher.qualification);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
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
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'dob': dobController.text,
        'secondaryPhone': secondaryPhoneController.text,
        'companyName': companyNameController.text,
        'position': positionController.text,
        'program': programController.text,
        'sponsor': sponsorController.text,
      };

      // Ensure the teacher ID is not null
      final teacherId = widget.teacher.id;
      if (teacherId == null) {
        throw Exception('teacher ID is null');
      }

      await _firebaseService.updateTeacherData(teacherId, updatedData, null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('teacher profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating teacher profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('teacher Profile'),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(widget.teacher.profilePic ?? ''),
                    ),
                    SizedBox(height: 16),
                    ProfileTextField(
                        controller: firstNameController, title: 'First Name'),
                    SizedBox(height: 8),
                    ProfileTextField(
                        controller: lastNameController, title: 'Last Name'),
                    SizedBox(height: 8),
                    ProfileTextField(
                        controller: emailController, title: 'Email'),
                    SizedBox(height: 8),
                    ProfileTextField(
                        controller: phoneNumberController,
                        title: 'Phone Number'),
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
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        ProfileTextField(
                            controller: dobController, title: 'Date of Birth'),
                        SizedBox(height: 8),
                        ProfileTextField(
                            controller: secondaryPhoneController,
                            title: 'Secondary Phone'),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                kMediumVerticalSpace,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 400,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        ProfileTextField(
                            controller: companyNameController,
                            title: 'Company Name'),
                        SizedBox(height: 8),
                        ProfileTextField(
                            controller: positionController, title: 'Position'),
                        SizedBox(height: 8),
                        ProfileTextField(
                            controller: programController, title: 'Program'),
                        SizedBox(height: 8),
                        ProfileTextField(
                            controller: sponsorController, title: 'Sponsor'),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            kMediumVerticalSpace,
            ElevatedButton(onPressed: _saveChanges, child: Text("Save"))
          ],
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

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
          fillColor: secondaryColor,
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
