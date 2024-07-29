import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../constants.dart';
import '../../../../../responsive.dart';
import 'services.dart';
import 'package:image_picker/image_picker.dart';

class StudentRegistrationForm extends StatefulWidget {
  const StudentRegistrationForm({super.key});

  @override
  StudentRegistrationFormState createState() => StudentRegistrationFormState();
}

class StudentRegistrationFormState extends State<StudentRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emergancyNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController instalmentController = TextEditingController();
  TextEditingController secondaryPhoneController = TextEditingController();
  TextEditingController secondaryEmailController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();
  List<String> programs = [];
  List<String> sponsors = [];
  String? selectedProgram;
  String? selectedSponsor;
  Uint8List? _profileImage;
  DateTime? _selectedDate;
  String? _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
    _fetchSponsors();
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

  void _registerStudent() {
    if (_formKey.currentState!.validate()) {
      if (_gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select gender')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> studentData = {
        'firstName': firstNameController.text,
        'middleName': middleNameController.text,
        'lastName': lastNameController.text,
        'dob': dobController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'companyName': companyNameController.text,
        'position': positionController.text,
        'program': selectedProgram,
        'sponsor': selectedSponsor,
        'instalment': instalmentController.text,
        'secondaryPhone': secondaryPhoneController.text,
        'secondaryEmail': secondaryEmailController.text,
        'gender': _gender,
      };

      _firebaseService.registerStudent(studentData, _profileImage).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student Registered Successfully')),
        );
        _clearFormFields();
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register student $error')),
        );
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _clearFormFields() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    dobController.clear();
    phoneNumberController.clear();
    emailController.clear();
    passwordController.clear();
    emergancyNumberController.clear();
    companyNameController.clear();
    positionController.clear();
    instalmentController.clear();
    secondaryPhoneController.clear();
    secondaryEmailController.clear();
    setState(() {
      _profileImage = null;
      _selectedDate = null;
      selectedProgram = null;
      selectedSponsor = null;
      _gender = null;
    });
  }

  String? _validateRequiredField(String? value) {
    if (value!.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmailField(String? value) {
    if (value!.isEmpty) {
      return 'This field is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumberField(String? value) {
    if (value!.isEmpty) {
      return 'This field is required';
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Widget _buildFormFields(BuildContext context) {
    return Card(
      color: MaterialStateColor.resolveWith((states) => Colors.white),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLeftColumnFields(),
                _buildRightColumnFields(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumnFields() {
    return Column(
      children: [
        _buildDatePicker(),
        const SizedBox(height: 16),
        RegistrationTextField(
          textController: phoneNumberController,
          title: 'Phone Number',
          validator: _validatePhoneNumberField,
        ),
        const SizedBox(height: 16),
        RegistrationTextField(
          textController: passwordController,
          title: 'Password',
          validator: _validateRequiredField,
        ),
        const SizedBox(height: 16),
        RegistrationTextField(
          textController: emailController,
          title: 'Email',
          validator: _validateEmailField,
        ),
        const SizedBox(height: 16),
        RegistrationTextField(
          textController: secondaryEmailController,
          title: 'Secondary Email',
        ),
      ],
    );
  }

  Widget _buildRightColumnFields() {
    return Column(
      children: [
        RegistrationTextField(
          textController: secondaryPhoneController,
          title: 'Secondary Phone',
        ),
        const SizedBox(height: 16),
        RegistrationTextField(
          textController: companyNameController,
          title: 'Company Name',
          validator: _validateRequiredField,
        ),
        const SizedBox(height: 16),
        RegistrationTextField(
          textController: positionController,
          title: 'Position',
          validator: _validateRequiredField,
        ),
        const SizedBox(height: 16),
        _buildProgramDropdown(),
        const SizedBox(height: 16),
        _buildSponsorAndInstalmentFields(),
      ],
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 50,
      width: 350,
      child: TextFormField(
        controller: dobController,
        validator: _validateRequiredField,
        readOnly: true,
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light().copyWith(
                    primary: primaryColor,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            setState(() {
              _selectedDate = pickedDate;
              dobController.text =
              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
            });
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          hintText: 'Select Date',
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
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

  Widget _buildSponsorAndInstalmentFields() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 250,
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
            icon: Container(), // Remove the dropdown icon
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 50,
          width: 100,
          child: TextFormField(
            controller: instalmentController,
            decoration: InputDecoration(
              filled: true,
              fillColor: primaryColor,
              hintText: 'Instalment',
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 900,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (Responsive.isMobile(context)) _buildProfileSectionMobile(context),
                  if (!Responsive.isMobile(context)) _buildProfileSectionDesktop(context),
                  const SizedBox(height: 32),
                  _buildFormFields(context),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 150,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        onPressed: _isLoading ? null : _registerStudent,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        )
                            : const Text('Register', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSectionMobile(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: pickImage,
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
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      RegistrationTextField(
                        textController: firstNameController,
                        title: 'First Name',
                        validator: _validateRequiredField,
                      ),
                      const SizedBox(height: 16),
                      RegistrationTextField(
                        textController: middleNameController,
                        title: 'Middle Name',
                      ),
                      const SizedBox(height: 16),
                      RegistrationTextField(
                        textController: lastNameController,
                        title: 'Last Name',
                        validator: _validateRequiredField,
                      ),
                    ],
                  ),
                  kLargeHorizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gender', style: TextStyle(color: primaryColor)),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: _gender,
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                          const Text('Male', style: TextStyle(color: primaryColor)),
                          Radio<String>(
                            value: 'Female',
                            groupValue: _gender,
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                          const Text('Female', style: TextStyle(color: primaryColor)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSectionDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Center(
        child: Row(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 50,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : CircleAvatar(
                  radius: 48,
                  backgroundImage: MemoryImage(_profileImage!),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        RegistrationTextField(
                          textController: firstNameController,
                          title: 'First Name',
                          validator: _validateRequiredField,
                        ),
                        const SizedBox(height: 16),
                        RegistrationTextField(
                          textController: middleNameController,
                          title: 'Middle Name',
                        ),
                        const SizedBox(height: 16),
                        RegistrationTextField(
                          textController: lastNameController,
                          title: 'Last Name',
                          validator: _validateRequiredField,
                        ),
                      ],
                    ),
                    kLargeHorizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gender', style: TextStyle(color: primaryColor)),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Male',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                            const Text('Male', style: TextStyle(color: primaryColor)),
                            Radio<String>(
                              value: 'Female',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                            const Text('Female', style: TextStyle(color: primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class RegistrationTextField extends StatelessWidget {
  const RegistrationTextField({
    super.key,
    required this.textController,
    required this.title,
    this.validator,
  });

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
        validator: validator,
        style: const TextStyle(color: primaryColor), // Set the input text color to blue
        decoration: InputDecoration(
          filled: true,
          fillColor: secondaryColor,
          hintText: title,
          hintStyle: const TextStyle(color: primaryColor, fontSize: 14),
          prefixIcon: _getIconForField(title),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Icon _getIconForField(String title) {
    switch (title) {
      case 'First Name':
        return const Icon(Icons.person, color: primaryColor);
      case 'Last Name':
        return const Icon(Icons.person, color: primaryColor);
      case 'Phone Number':
        return const Icon(Icons.phone, color: primaryColor);
      case 'Email':
        return const Icon(Icons.email, color: primaryColor);
      case 'Password':
        return const Icon(Icons.lock, color: primaryColor);
      case 'Secondary Phone':
        return const Icon(Icons.phone_android, color: primaryColor);
      case 'Company Name':
        return const Icon(Icons.business, color: primaryColor);
      case 'Position':
        return const Icon(Icons.work, color: primaryColor);
      case 'Secondary Email':
        return const Icon(Icons.email_outlined, color: primaryColor);
      default:
        return const Icon(Icons.text_fields, color: primaryColor);
    }
  }
}

class Students {
  final String id;
  final String firstName;
  final String lastName;
  final String dob;
  final String phoneNumber;
  final String email;
  final String password;
  final String companyName;
  final String position;
  final String program;
  final String sponsor;
  final String instalment;
  final String secondaryPhone;
  final String secondaryEmail;
  final String gender;

  Students({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.companyName,
    required this.position,
    required this.program,
    required this.sponsor,
    required this.instalment,
    required this.secondaryPhone,
    required this.secondaryEmail,
    required this.gender,
  });
}

class StudentTable extends StatelessWidget {
  final List<Students> students;

  const StudentTable({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('First Name')),
        DataColumn(label: Text('Last Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Actions')),
      ],
      rows: students.map((student) {
        return DataRow(cells: [
          DataCell(Text(student.id)),
          DataCell(Text(student.firstName)),
          DataCell(Text(student.lastName)),
          DataCell(Text(student.email)),
          DataCell(
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: student.id != null
                  ? () => _editStudent(context, student)
                  : null,
            ),
          ),
        ]);
      }).toList(),
    );
  }

  void _editStudent(BuildContext context, Students student) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StudentRegistrationForm(),
        settings: RouteSettings(
          arguments: student,
        ),
      ),
    );
  }
}
