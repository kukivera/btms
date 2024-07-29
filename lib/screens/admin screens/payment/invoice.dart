import 'dart:typed_data';

import 'package:bruh_finance_tms/screens/admin%20screens/payment/student_provider.dart';
import 'package:flutter/material.dart';

import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bruh_finance_tms/constants.dart';
import '../../../widgets/header.dart';
import 'package:flutter/cupertino.dart';
import '../programs/components/fetchAndOtherProgram.dart';

import '../programs/components/provider.dart';
import '../programs/components/program_model.dart';
import '../programs/components/batch_model.dart';

import 'package:pdf/widgets.dart' as pw;

import '../programs/components/sectionModel.dart';
// import 'student_provider.dart';
// import 'package:bruh_finance_tms/screens/admin screens/registration/student/student data model/Student_model.dart';
class InvoiceGenerator extends StatefulWidget {
  const InvoiceGenerator({Key? key}) : super(key: key);

  @override
  _InvoiceGeneratorState createState() => _InvoiceGeneratorState();
}

class _InvoiceGeneratorState extends State<InvoiceGenerator> {
  String? selectedProgram;
  Batch? selectedBatch;
  Set<String> selectedSectionIds = {}; // Track selected section IDs
  bool isFetchingStudents = false; // Flag to track if students are being fetched
  List<Students> fetchedStudents = []; // List to hold fetched students
  String? selectedSponsor; // Track the selected sponsor
  double feePerStudent = 0.0; // Track the fee per student
  String companyName = 'BRUH Finance';
  bool isFetchingBatch = false;


  // Store the company name

  Future<List<Students>> _fetchStudentsForSections(
      List<DocumentReference> sectionRefs) async {
    List<Students> students = [];

    try {
      for (DocumentReference sectionRef in sectionRefs) {
        print('Querying for section: ${sectionRef.path}'); // Debugging log

        DocumentSnapshot sectionDoc = await sectionRef.get();

        if (!sectionDoc.exists) {
          print('Section with reference ${sectionRef.path} does not exist');
          continue;
        }

        if (sectionDoc.data() == null) {
          print('Section data for ${sectionRef.path} is null');
          continue;
        }

        Section section = Section.fromFirestore(
            sectionDoc as DocumentSnapshot<Map<String, dynamic>>);

        List<Future<
            DocumentSnapshot<Map<String, dynamic>>?>> studentFutures = section
            .students.map((studentRef) async {
          DocumentSnapshot studentDoc = await studentRef.get();
          if (!studentDoc.exists || studentDoc.data() == null) {
            print('Student with reference ${studentRef
                .path} does not exist or has null data');
            return null;
          }
          return studentDoc as DocumentSnapshot<Map<String, dynamic>>;
        }).toList();

        List<DocumentSnapshot<Map<String, dynamic>>> studentDocs = (await Future
            .wait(studentFutures)).whereType<
            DocumentSnapshot<Map<String, dynamic>>>().toList();

        students.addAll(
            studentDocs.map((doc) => Students.fromFirestore(doc)).toList());
      }
    } catch (e) {
      print('Error fetching students: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students.')),
      );
    }

    return students;
  }

  Future<void> _fetchCompanyName() async {
    try {
      DocumentSnapshot companyDoc = await FirebaseFirestore.instance.collection(
          'company').doc('companyInfo').get();
      if (companyDoc.exists && companyDoc.data() != null) {
        setState(() {
          companyName = companyDoc.get('name');
        });
      }
    } catch (e) {
      print('Error fetching company name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ProgramProvider(
                FetchPrograms(
                    ProgramRepositoryImpl(FirebaseFirestore.instance)),
              ),
        ),
        ChangeNotifierProvider(
          create: (_) => BatchProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (_) => SectionProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (_) => StudentProvider(FirebaseFirestore.instance),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.orange,
        body: Consumer<ProgramProvider>(
          builder: (context, programProvider, child) {
            if (programProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (programProvider.errorMessage != null) {
              return Center(child: Text(programProvider.errorMessage!));
            }

            // Set the initial value of selectedProgram to the name of the first program
            selectedProgram ??= programProvider.programs.isNotEmpty
                ? programProvider.programs.first.name
                : null;

            // Find the selected program
            Program? selectedProgramObj = programProvider.programs
                .firstWhere((program) => program.name == selectedProgram);

            // Extract unique sponsors from fetched students
            List<String> uniqueSponsors = fetchedStudents.map((
                student) => student.sponsor ?? '').toSet().toList();

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(title: 'Invoice Generator'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 130,
                              decoration: kMediumBoxDecoration.copyWith(
                                  color: secondaryColor),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: Container(width: 0),
                                  value: selectedProgram,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedProgram = newValue;
                                      selectedBatch = null;
                                      selectedSectionIds
                                          .clear(); // Clear selected sections
                                      fetchedStudents
                                          .clear(); // Clear fetched students
                                    });
                                  },
                                  items: programProvider.programs.map((
                                      Program program) {
                                    return DropdownMenuItem<String>(
                                      value: program.name,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              program.name,
                                              style: kMediumColoredTextStyle,
                                            ),
                                          ),
                                          kLargeHorizontalSpace,
                                          Icon(Icons.circle,
                                              color: program.color),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Display batches for the selected program
                        Expanded(
                          child: FutureBuilder<List<Batch>>(
                            future: Provider.of<BatchProvider>(
                                context, listen: false)
                                .getBatchesByProgramId(selectedProgramObj!.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                                  !isFetchingStudents) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              List<Batch>? batches = snapshot.data;

                              if (batches == null || batches.isEmpty) {
                                return Text(
                                    'No batches found for the selected program');
                              }

                              // Display the list of batches
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Batches for ${selectedProgramObj.name}',
                                    style: kMediumColoredTextStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 20,
                                    children: batches.map((batch) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedBatch = batch;
                                            selectedSectionIds
                                                .clear(); // Clear selected sections
                                            fetchedStudents
                                                .clear(); // Clear fetched students
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: kMediumBoxDecoration
                                              .copyWith(
                                            color: selectedBatch == batch
                                                ? Colors.blue
                                                : secondaryColor,
                                          ),
                                          child: Text(
                                            batch.year.toString(),
                                            style: kLargeColoredBoldTextStyle,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),


                    if (selectedBatch != null)
                      FutureBuilder<List<Section>>(
                        future: Provider.of<SectionProvider>(
                            context, listen: false)
                            .getSectionsByBatchId(
                            selectedProgramObj!.id, selectedBatch!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting && !isFetchingBatch) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          List<Section>? sections = snapshot.data;

                          if (sections == null || sections.isEmpty) {
                            return Text(
                                'No sections found for the selected batch');
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Sections for batch ${selectedBatch!.year}',
                                style: kMediumColoredTextStyle,
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children: sections.map((section) {
                                  return CheckboxListTile(
                                    title: Text(section.name),
                                    value: selectedSectionIds.contains(
                                        section.id),
                                    // Check based on selectedSectionIds
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedSectionIds.add(section
                                              .id); // Add section ID to selectedSectionIds
                                        } else {
                                          selectedSectionIds.remove(section
                                              .id); // Remove section ID from selectedSectionIds
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isFetchingStudents = true;
                                  });

                                  // Fetch students based on selected sections
                                  List<
                                      DocumentReference> sectionRefs = selectedSectionIds
                                      .map((id) =>
                                      FirebaseFirestore.instance.doc(
                                          'sections/$id'))
                                      .toList();

                                  print(
                                      'Fetching students for sections: $sectionRefs'); // Debugging log

                                  List<
                                      Students> students = await _fetchStudentsForSections(
                                      sectionRefs);

                                  print(
                                      'Fetched students: $students'); // Debugging log

                                  setState(() {
                                    fetchedStudents = students;
                                    isFetchingStudents = false;
                                  });
                                },
                                child: const Text('Fetch Students'),
                              ),
                            ],
                          );
                        },
                      ),
                    if (fetchedStudents.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Filter by Sponsor',
                              style: kMediumColoredTextStyle,
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              value: selectedSponsor,
                              hint: const Text('Select Sponsor'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSponsor = newValue;
                                });
                              },
                              items: uniqueSponsors.map((String sponsor) {
                                return DropdownMenuItem<String>(
                                  value: sponsor,
                                  child: Text(sponsor),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Fee per Student',
                              style: kMediumColoredTextStyle,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: feePerStudent.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  feePerStudent = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Students',
                              style: kMediumColoredTextStyle,
                            ),
                            const SizedBox(height: 8),
                            Table(
                              border: TableBorder.all(),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Name',
                                          style: kLargeColoredBoldTextStyle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Sponsor',
                                          style: kLargeColoredBoldTextStyle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Fee',
                                          style: kLargeColoredBoldTextStyle),
                                    ),
                                  ],
                                ),
                                ...fetchedStudents
                                    .where((student) =>
                                selectedSponsor == null ||
                                    student.sponsor == selectedSponsor)
                                    .map((student) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            '${student.firstName ??
                                                ''} ${student.lastName ?? ''}'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(student.sponsor ?? ''),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            feePerStudent.toStringAsFixed(2)),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Generate invoice based on selected students and fees
                                _generateInvoice();
                              },
                              child: const Text('Print Invoice'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Future<void> _generateInvoice() async {
    final pdf = pw.Document();

    // Define a method to add a page to the PDF
    void addPage(List<Students> students, String sponsor) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                    children: [

                  pw.Container(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Company Name: $companyName', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Bill to: $sponsor', style: pw.TextStyle(fontSize: 18)),
                      pw.Text( sponsor, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                ]),
            )]),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Name', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Sponsor', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Fee', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...students.map(
                          (student) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8.0),
                              child: pw.Text('${student.firstName ?? ''} ${student.lastName ?? ''}'),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8.0),
                              child: pw.Text(student.sponsor ?? ''),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8.0),
                              child: pw.Text(feePerStudent.toStringAsFixed(2)),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total: ${(students.length * feePerStudent).toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ],
            );
          },
        ),
      );
    }

    // Filter students by selected sponsor
    List<Students> filteredStudents = fetchedStudents
        .where((student) => selectedSponsor == null || student.sponsor == selectedSponsor)
        .toList();

    // Group students by sponsor if no specific sponsor is selected
    if (selectedSponsor == null) {
      final Map<String, List<Students>> groupedStudents = {};

      for (final student in filteredStudents) {
        final sponsor = student.sponsor ?? 'No Sponsor';
        if (groupedStudents.containsKey(sponsor)) {
          groupedStudents[sponsor]!.add(student);
        } else {
          groupedStudents[sponsor] = [student];
        }
      }

      // Add a page for each group of students
      groupedStudents.forEach((sponsor, students) {
        addPage(students, sponsor);
      });
    } else {
      // Add a single page for the filtered students
      addPage(filteredStudents, selectedSponsor!);
    }

    // Save the PDF file and show the printing dialog
    final Uint8List pdfBytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }
}
class Students {
  final String? dob, email, firstName, lastName, name, phoneNumber, program, role, profilePic, companyName, instalment, position, secondaryphone, batch, sponsor, id;
  final List<DocumentReference>? sections;

  Students({
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.name,
    this.phoneNumber,
    this.program,
    this.role,
    this.profilePic,
    this.companyName,
    this.instalment,
    this.position,
    this.secondaryphone,
    this.batch,
    this.sections,
    this.sponsor,
    this.id,
  });

  factory Students.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic>? data = doc.data();
    if (data == null) {
      throw StateError("Missing data for student ID: ${doc.id}");
    }
    return Students(
      dob: data['dob'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      program: data['program'],
      role: data['role'],
      profilePic: data['profilePic'],
      companyName: data['companyName'],
      instalment: data['instalment'],
      position: data['position'],
      secondaryphone: data['secondaryphone'],
      batch: data['batch'],
      sections: (data['sections'] as List<dynamic>?)
          ?.map((section) => section as DocumentReference)
          .toList(),
      sponsor: data['sponsor'],
      id: doc.id,
    );
  }
}

// class Section {
//   final String id;
//   final String programId;
//   final String batchId;
//   final String name;
//   final List<DocumentReference> students;
//   final List<DocumentReference> courses;
//
//   Section({
//     required this.id,
//     required this.programId,
//     required this.batchId,
//     required this.name,
//     required this.students,
//     required this.courses,
//   });
//
//   factory Section.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
//     Map<String, dynamic>? data = doc.data();
//     if (data == null) {
//       throw StateError("Missing data for section ID: ${doc.id}");
//     }
//     return Section(
//       id: doc.id,
//       programId: data['programId'],
//       batchId: data['batchId'],
//       name: data['name'],
//       students: List<DocumentReference>.from(data['students']),
//       courses: List<DocumentReference>.from(data['courses']),
//     );
//   }
// }
// class SectionProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool sectionIsLoading = false;
//   String? errorMessage;
//   List<Section> sections = [];
//
//   SectionProvider(FirebaseFirestore instance);
//
//   Future<List<Section>> getSectionsByBatchId(String programId, String batchId) async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
//           .collection('sections')
//           .where('programId', isEqualTo: programId)
//           .where('batchId', isEqualTo: batchId)
//           .get();
//
//       List<Section> sections = querySnapshot.docs
//           .map((doc) => Section.fromFirestore(doc))
//           .toList();
//
//       return sections;
//     } catch (error) {
//       print('Error fetching sections: $error');
//       rethrow;
//     }
//   }
//
//   Stream<List<Section>> fetchSectionsStream(String programId, String batchId) {
//     return _firestore
//         .collection('sections')
//         .where('programId', isEqualTo: programId)
//         .where('batchId', isEqualTo: batchId)
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => Section.fromFirestore(doc)).toList());
//   }
//
//   Future<void> deleteSection(String programId, String batchId, String sectionId) async {
//     try {
//       await _firestore
//           .collection('sections')
//           .doc(sectionId)
//           .delete();
//     } catch (e) {
//       errorMessage = 'Error deleting section: $e';
//       notifyListeners();
//     }
//   }
// }
//
