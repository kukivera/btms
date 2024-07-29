import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../widgets/header.dart';
import '../../admin screens/programs/components/fetchAndOtherProgram.dart';

import '../../admin screens/programs/components/provider.dart';
import '../../admin screens/programs/components/program_model.dart';
import 'resource_program_dropdown.dart';
import '../../admin screens/programs/components/batch_model.dart';
class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  Program? selectedProgram;
  Batch? selectedBatch;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProgramProvider(
              FetchPrograms(ProgramRepositoryImpl(FirebaseFirestore.instance))),
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
                    const Header(title: 'Resources'),
                    ProgramDropdownContainer(
                      selectedProgram: selectedProgram,
                      onChanged: (Program? program) {
                        setState(() {
                          selectedProgram = program;
                          selectedBatch = null; // Reset selected batch when program changes
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (selectedProgram != null)
                      FutureBuilder<List<Batch>>(
                        future: batchProvider.getBatchesByProgramId(selectedProgram!.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No batches found'));
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Batches:',
                                  style: kMediumColoredTextStyle,
                                ),
                                SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: snapshot.data!.map((batch) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedBatch = batch;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(10),
                                            color: selectedBatch?.year == batch.year
                                                ? primaryColor
                                                : secondaryColor,
                                          ),
                                          child: Text(
                                            batch.year.toString(),
                                            style: TextStyle(
                                              color: selectedBatch?.year == batch.year
                                                  ? secondaryColor
                                                  : primaryColor,
                                              fontWeight: selectedBatch == batch
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                if (selectedBatch != null)
                                  FutureBuilder<List<DocumentSnapshot>>(
                                    future: batchProvider.getDocumentsForBatch(selectedBatch!.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(vertical: 16),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              batchProvider.uploadFile(selectedBatch!.id);
                                            },
                                            child: const Text('Attach Documents'),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Batch year ${selectedBatch?.year} Documents:',
                                              style:kMediumColoredTextStyle,
                                            ),
                                            kSmallVerticalSpace,
                                            Column(
                                              children: snapshot.data!.map((document) {
                                                // Extracting document data
                                                final String docId = document.id;
                                                final String fileName = document['name'] as String;

                                                return Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.insert_drive_file,size:20, color: primaryColor,),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            fileName,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: kMediumColoredTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      kMediumVerticalSpace,
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              // Implement download document functionality
                                                              batchProvider.downloadDocument(selectedBatch!.id, fileName);
                                                            },
                                                            icon: const Icon(Icons.download,color: primaryColor,),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              // Implement delete document functionality
                                                              batchProvider.deleteDocument(selectedBatch!.id, fileName).then((_) {
                                                                // Refresh documents list after deletion
                                                                setState(() {});
                                                              }).catchError((error) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Failed to delete document: $error',style: kMediumColoredTextStyle,),
                                                                ));
                                                              });
                                                            },
                                                            icon: const Icon(Icons.delete,color: primaryColor,),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            Container(
                                              decoration: kBasicBoxDecoration.copyWith(color: secondaryColor),
                                              margin: const EdgeInsets.symmetric(vertical: 16),
                                              child: IconButton(
                                                style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => secondaryColor)),
                                                onPressed: () {
                                                  batchProvider.uploadFile(selectedBatch!.id);
                                                },
                                                icon: const Icon(Icons.attach_file, color: primaryColor, size:50 ,),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                              ],
                            );
                          }
                        },
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
}


class DocumentContainer extends StatelessWidget {
  final DocumentReference documentReference;
  final VoidCallback onDelete;
  final VoidCallback onDownload;

  const DocumentContainer({super.key,
    required this.documentReference,
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 48, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            // Extract file name from document path
            documentReference.path.split('/').last,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: onDownload,
                icon: const Icon(Icons.download),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
