import 'dart:typed_data';

import 'package:bruh_finance_tms/screens/admin%20screens/registration/teacher/teacher%20registartion/teachers_registration_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../constants.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/header.dart';
import '../../student/student registation/services.dart';

import 'package:image_picker/image_picker.dart';



class TeacherRegistrationForm extends StatefulWidget {
  const TeacherRegistrationForm({Key? key}) : super(key: key);

  @override
  _TeacherRegistrationFormState createState() =>
      _TeacherRegistrationFormState();
}

class _TeacherRegistrationFormState extends State<TeacherRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController(); // Added middleNameController
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController coursesController = TextEditingController();
  TextEditingController secondaryPhoneController = TextEditingController();

  final TeacherFirebaseService _teacherfirebaseService =
  TeacherFirebaseService();
  final FirebaseService _firebaseService = FirebaseService();

  List<String> programs = [];
  List<String> courses = [];
  Uint8List? _profileImage;
  String? selectedCourses;
  String? selectedProgram;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
    _fetchCourses();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
    }
  }

  Future<void> _fetchPrograms() async {
    try {
      List<String> fetchedPrograms =
      (await _firebaseService.fetchPrograms()).cast<String>();
      setState(() {
        programs = fetchedPrograms;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load programs')),
      );
    }
  }

  Future<void> _fetchCourses() async {
    try {
      List<String> fetchedCourses = await _firebaseService.fetchCourses();
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Courses')),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose(); // Dispose middleNameController
    dobController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    coursesController.dispose();
    qualificationController.dispose();
    secondaryPhoneController.dispose();
    super.dispose();
  }

  String? validateEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

          children: [
            // Header widget or title
            const Header(title: 'Teachers Registration'),
            Center(
              child: SizedBox(
                width: 900,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Center(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: pickImage,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.cyan,
                                    radius: 50,
                                    child: _profileImage == null
                                        ? const Icon(Icons.person,
                                        size: 40, color: Colors.white)
                                        : CircleAvatar(
                                      radius: 48,
                                      backgroundImage:
                                      MemoryImage(_profileImage!),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  children: [
                                    RegistrationTextField(
                                      textController: firstNameController,
                                      title: 'First Name',
                                      validator: (value) =>
                                          validateEmpty(value, 'First Name'),
                                    ),
                                    kTextFieldVerticalSpace,
                                    RegistrationTextField(
                                      textController: lastNameController,
                                      title: 'Last Name',
                                      validator: (value) =>
                                          validateEmpty(value, 'Last Name'),
                                    ),
                                    kTextFieldVerticalSpace,
                                    RegistrationTextField(
                                      textController: middleNameController,
                                      title: 'Middle Name',
                                      validator: (value) =>
                                          validateEmpty(value, 'Middle Name'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        kLargeVerticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 350,
                                  child: TextButton(
                                    onPressed: () async {
                                      final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              colorScheme:
                                              ColorScheme.light().copyWith(
                                                primary: Colors.blue,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          dobController.text =
                                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          primaryColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            dobController.text.isEmpty
                                                ? 'Select Date of birth'
                                                : 'Date of birth: ${dobController.text}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                kTextFieldVerticalSpace,
                                RegistrationTextField(
                                  textController: dobController,
                                  title: 'Date of Birth',
                                  validator: (value) => validateDate(value),
                                ),
                                kTextFieldVerticalSpace,
                                RegistrationTextField(
                                  textController: phoneNumberController,
                                  title: 'Phone Number',
                                  validator: (value) =>
                                      validatePhoneNumber(value),
                                ),
                                kTextFieldVerticalSpace,
                                RegistrationTextField(
                                  textController: emailController,
                                  title: 'Email',
                                  validator: (value) => validateEmail(value),
                                ),
                                kTextFieldVerticalSpace,
                                RegistrationTextField(
                                  textController: passwordController,
                                  title: 'Password',
                                  validator: (value) => validatePassword(value),
                                ),
                                kTextFieldVerticalSpace,
                              ],
                            ),
                            Column(
                              children: [
                                RegistrationTextField(
                                  textController: addressController,
                                  title: 'Address',
                                  validator: (value) =>
                                      validateEmpty(value, 'Address'),
                                ),
                                kTextFieldVerticalSpace,
                                RegistrationTextField(
                                  textController: qualificationController,
                                  title: 'Qualifications',
                                  validator: (value) =>
                                      validateEmpty(value, 'Qualifications'),
                                ),
                                kTextFieldVerticalSpace,
                                SizedBox(
                                  height: 50,
                                  width: 350,
                                  child: DropdownButtonFormField<String>(
                                    value: selectedCourses,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCourses = newValue;
                                      });
                                    },
                                    items: courses.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: primaryColor,
                                      hintText: 'Courses',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) =>
                                        validateEmpty(value, 'Courses'),
                                  ),
                                ),
                                kTextFieldVerticalSpace,
                                SizedBox(
                                  height: 50,
                                  width: 350,
                                  child: DropdownButtonFormField<String>(
                                    value: selectedProgram,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedProgram = newValue;
                                      });
                                    },
                                    items: programs.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: primaryColor,
                                      hintText: 'Program',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) =>
                                        validateEmpty(value, 'Program'),
                                  ),
                                ),
                                kTextFieldVerticalSpace,
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 200,
                                      child: TextButton(
                                        onPressed: () async {
                                          final DateTime? pickedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data: ThemeData.light().copyWith(
                                                  colorScheme: ColorScheme.light()
                                                      .copyWith(
                                                    primary: Colors.blue,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (pickedDate != null) {
                                            startDateController.text =
                                            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              primaryColor),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Select Start Date',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    kSmallHorizontalSpace,
                                    Container(
                                      height: 50,
                                      width: 200,
                                      child: TextButton(
                                        onPressed: () async {
                                          final DateTime? pickedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data: ThemeData.light().copyWith(
                                                  colorScheme: ColorScheme.light()
                                                      .copyWith(
                                                    primary: Colors.blue,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (pickedDate != null) {
                                            endDateController.text =
                                            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              primaryColor),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Select End Date',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                Map<String, dynamic> teachersData = {
                                  'firstName': firstNameController.text,
                                  'lastName': lastNameController.text,
                                  'middleName': middleNameController.text, // Include middleName
                                  'dob': dobController.text,
                                  'startDate': startDateController.text,
                                  'endDate': endDateController.text,
                                  'phoneNumber': phoneNumberController.text,
                                  'password': passwordController.text,
                                  'email': emailController.text,
                                  'address': addressController.text,
                                  'qualification': qualificationController.text,
                                  'courses': selectedCourses,
                                  'program': selectedProgram,
                                  'secondaryPhone': secondaryPhoneController.text,
                                };

                                try {
                                  await _teacherfirebaseService.registerTeachers(
                                      teachersData, _profileImage);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Teacher Registered Successfully'),
                                    ),
                                  );

                                  firstNameController.clear();
                                  lastNameController.clear();
                                  middleNameController.clear(); // Clear middleNameController
                                  dobController.clear();
                                  startDateController.clear();
                                  endDateController.clear();
                                  phoneNumberController.clear();
                                  passwordController.clear();
                                  emailController.clear();
                                  addressController.clear();
                                  qualificationController.clear();
                                  coursesController.clear();
                                  secondaryPhoneController.clear();
                                } catch (error) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('Failed to register Teacher'),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text('Register',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RegistrationTextField extends StatelessWidget {
  const RegistrationTextField({
    Key? key,
    required this.textController,
    required this.title,
    this.validator,
  }) : super(key: key);

  final TextEditingController textController;
  final String title;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 350,
      child: TextFormField(
        controller: textController,
        style: TextStyle(color: primaryColor), // Set text color to blue
        decoration: InputDecoration(
          filled: true,
          fillColor: secondaryColor,
          hintText: title,
          hintStyle: TextStyle(color: primaryColor, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }
}