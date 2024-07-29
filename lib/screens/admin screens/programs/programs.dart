import 'package:bruh_finance_tms/constants.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/programs/assign_student/assign_student.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/programs/containers.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/programs/schedule_and_assign/schedule_and_Assign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/header.dart';
import 'components/batch_model.dart';
import 'components/fetchAndOtherProgram.dart';
import 'components/program_model.dart';
import 'components/provider.dart';
import 'dialoge_service.dart';
import 'components/sectionModel.dart';


class Programs extends StatefulWidget {
  const Programs({super.key});

  @override
  ProgramsState createState() => ProgramsState();
}

class ProgramsState extends State<Programs> {
  Program? selectedProgram;
  Batch? selectedBatch;
  Section? selectedSection;
  bool batchIsLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ProgramProvider(FetchPrograms(
                ProgramRepositoryImpl(FirebaseFirestore.instance))),
          ),
          ChangeNotifierProvider(
            create: (_) => BatchProvider(FirebaseFirestore.instance),
          ),
          ChangeNotifierProvider(
            create: (_) => SectionProvider(FirebaseFirestore.instance),
          ),
        ],
        child: Scaffold(
            body: Consumer3<ProgramProvider, BatchProvider, SectionProvider>(
                builder: (context, programProvider, batchProvider, sectionProvider, child) {
                  if (programProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (programProvider.errorMessage != null) {
                    return Center(child: Text(programProvider.errorMessage!));
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Header(title: 'Programs'),
                            Align(
                              alignment: Alignment.topRight,
                              child: AddProgramContainer(
                                onAddProgram: () {
                                  DialogService.showAddProgramDialog(
                                    context,
                                        (Program program) {
                                      programProvider.loadPrograms();
                                    },
                                  );
                                },
                              ),
                            ),
                            Row(
                              children: programProvider.programs.map((program) {
                                return ProgramContainer(
                                  program: program,
                                  onTap: () {
                                    setState(() {
                                      selectedProgram = program;
                                      selectedBatch = null;
                                      selectedSection = null;
                                    });
                                  },
                                  onEdit: () {
                                    DialogService.showUpdateProgramDialog(
                                      context,
                                      program,
                                          (Program updatedProgram) {
                                        programProvider.updateProgram(updatedProgram);
                                      },
                                    );
                                  },
                                  onDelete: () {
                                    DialogService.showDeleteConfirmationDialog(
                                      context: context,
                                      itemId: program.id,
                                      title: 'Delete Program',
                                      deleteFunction: (id) async {
                                        await FirebaseFirestore.instance
                                            .collection('programs')
                                            .doc(id)
                                            .delete();
                                        programProvider.loadPrograms();
                                      },
                                    );
                                  },
                                  isTapped: selectedProgram == program,
                                );
                              }).toList(),
                            ),
                    if (selectedProgram != null)
                      StreamBuilder<List<Batch>>(
                        stream: batchProvider
                            .fetchBatchesStream(selectedProgram!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          List<Batch> batches = snapshot.data ?? [];

                          return batches.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Text(
                                      'Batches for ${selectedProgram!.name}',
                                      style: kMediumColoredTextStyle,),
                                    kSmallVerticalSpace,
                                    IconButton(
                                      onPressed: () {
                                        DialogService.showAddBatchDialog(
                                            context, selectedProgram!.id);
                                      },
                                      icon: const Icon(Icons.add,color: primaryColor,),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Text(
                                      'Batches for ${selectedProgram!.name}',
                                      style: kLargeColoredBoldTextStyle,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Row(
                                          children: batches.map((batch) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: BatchContainer(
                                                batch: batch,
                                                onTap: () {
                                                  setState(() {
                                                    selectedBatch = batch;
                                                    selectedSection = null;


                                                  });
                                                },
                                                onDelete: (batchId) {
                                                  batchProvider.deleteBatch(selectedProgram!.id, batchId);
                                                },
                                                isTapped:  false,
                                                programId: selectedProgram!.id, // Ensure this line is present
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            DialogService.showAddBatchDialog(
                                                context, selectedProgram!.id);
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        },
                      ),
                    if (selectedBatch != null)
                      StreamBuilder<List<Section>>(
                        stream: sectionProvider.fetchSectionsStream(
                            selectedProgram!.id, selectedBatch!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          List<Section> sections = snapshot.data ?? [];

                          return sections.isEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Sections for program ${selectedProgram!.name}  batch  ${selectedBatch!.year}',
                                style: kMediumColoredTextStyle,
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                onPressed: () {
                                  DialogService.showAddSectionDialog(
                                      context,
                                      selectedProgram!.id,
                                      selectedBatch!.id);
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          )
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(

                                  'Sections for program ${selectedProgram!.name}  batch  ${selectedBatch!.year}',
                                  style: kMediumColoredTextStyle,

                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Row(
                                    children: sections.map((section) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: SectionContainer(
                                          section: section,
                                          onTap: () {
                                            setState(() {
                                              selectedSection = section;

                                            });
                                          },
                                          onDelete: (sectionId) {
                                            sectionProvider.deleteSection(
                                                selectedProgram!.id,
                                                selectedBatch!.id,
                                                sectionId);
                                          }, sectionIsTapped: false,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      DialogService.showAddSectionDialog(
                                          context,
                                          selectedProgram!.id,
                                          selectedBatch!.id);
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    kMediumVerticalSpace,
                    if (selectedSection != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomContainer(title: 'Schedule and Assign', icon:Icons.calendar_month, onTap: () {  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduleAndAssign(
                                selectedProgram: selectedProgram!.id,
                                selectedBatch: selectedBatch!.id,
                                selectedSection: selectedSection!.id,
                              ),
                            ),
                          );
                          },),
                          BottomContainer(title: 'Add Students', icon:Icons.group_add, onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssignStudent(
                                  selectedProgram: selectedProgram!.id,
                                  selectedBatch: selectedBatch!.id,
                                  selectedSection: selectedSection!.id,
                                ),
                              ),
                            );



                          },),





                        ],
                      )


                  ]),
            ),
          );
        })));
  }
}

class BottomContainer extends StatelessWidget {

 final String title;
 final IconData icon;
 final VoidCallback onTap;

  const BottomContainer({
    super.key, required this.title, required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        width:200 ,
        height: 150,
        decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Text( title,style: kMediumColoredBoldTextStyle,),
            Icon(icon,size: 60, color: primaryColor,),
          ],
        )
      ),
    );
  }
}
