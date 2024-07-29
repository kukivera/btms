import 'package:bruh_finance_tms/screens/admin%20screens/profile/courseProfile/components/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import 'package:bruh_finance_tms/screens/admin screens/profile/registration field.dart';



class CourseRegisterModal extends StatefulWidget {
  const CourseRegisterModal({super.key});

  @override
  State<CourseRegisterModal> createState() => _CourseRegisterModalState();
}

class _CourseRegisterModalState extends State<CourseRegisterModal> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController creditHourController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController numberOfClassController = TextEditingController();

  final CourseService courseService = CourseService();

  List<Program> programs = [];
  String? selectedProgramId;
  String? selectedProgramName;

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    try {
      List<Program> fetchedPrograms = await _firebaseService.fetchPrograms();
      setState(() {
        programs = fetchedPrograms;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load programs')),
      );
    }
  }

  bool _validateForm() {
    if (courseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course Name cannot be empty')),
      );
      return false;
    }
    if (creditHourController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credit Hour cannot be empty')),
      );
      return false;
    }
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty')),
      );
      return false;
    }
    if (courseCodeController.text.isEmpty || courseCodeController.text.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course Code cannot be empty and must be at most 4 characters')),
      );
      return false;
    }
    if (numberOfClassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Number of Classes cannot be empty')),
      );
      return false;
    }
    if (selectedProgramId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Program')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: secondaryColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Course',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'profile',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RegistrationTextField(
                textController: courseNameController,
                title: 'Course Name', maxLength: 200,
              ),
              kMediumVerticalSpace,
              RegistrationTextField(
                textController: creditHourController,
                title: 'Credit Hour', maxLength: 4,
              ),
              kMediumVerticalSpace,
              RegistrationTextField(
                textController: descriptionController,
                title: 'Description', maxLength: 200,
              ),
              kMediumVerticalSpace,
              RegistrationTextField(
                textController: courseCodeController,
                title: 'Course Code',
                maxLength: 4,
              ),
              kMediumVerticalSpace,
              RegistrationTextField(
                textController: numberOfClassController,
                title: 'No. of Classes', maxLength: 2,
              ),
              kMediumVerticalSpace,
              SizedBox(
                width: 350,
                child: DropdownButtonFormField<String>(
                  value: selectedProgramName,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProgramName = newValue!;
                      selectedProgramId = programs.firstWhere((program) => program.name == newValue).id;
                    });
                  },
                  items: programs.map<DropdownMenuItem<String>>((Program program) {
                    return DropdownMenuItem<String>(
                      value: program.name,
                      child: Text(program.name),
                    );
                  }).toList(),
                  icon: const Icon(Icons.add, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Program',
                    hintStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                          (states) => primaryColor,
                    ),
                  ),
                  onPressed: () async {
                    if (_validateForm()) {
                      try {
                        int numberOfClasses = int.parse(numberOfClassController.text);
                        await courseService.addCourse(
                          courseName: courseNameController.text,
                          creditHour: creditHourController.text,
                          description: descriptionController.text,
                          courseCode: courseCodeController.text,
                          number_of_classes: numberOfClasses,
                          programId: selectedProgramId!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Course registered successfully!'),
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error registering course: $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Add',
                    style: kWhiteText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Program {
  final String id;
  final String name;

  Program({required this.id, required this.name});
}

class FirebaseService {
  final CollectionReference programsCollection =
  FirebaseFirestore.instance.collection('programs');

  Future<List<Program>> fetchPrograms() async {
    final snapshot = await programsCollection.get();
    return snapshot.docs.map((doc) {
      return Program(id: doc.id, name: doc['name']);
    }).toList();
  }
}

// class CourseService {
//   final CollectionReference coursesCollection =
//   FirebaseFirestore.instance.collection('courses');
//
//   Future<void> addCourse({
//     required String courseName,
//     required String creditHour,
//     required String description,
//     required String courseCode,
//     required int number_of_classes,
//     required String programId,
//   }) async {
//     await coursesCollection.add({
//       'courseName': courseName,
//       'creditHour': creditHour,
//       'description': description,
//       'courseCode': courseCode,
//       'number_of_classes': number_of_classes,
//       'programId': programId,
//     });
//   }
// }