import 'package:bruh_finance_tms/constants.dart';
import '../../../widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../programs/components/fetchAndOtherProgram.dart';
import '../programs/components/provider.dart';
import '../programs/components/program_model.dart';
import '../programs/components/batch_model.dart';

class AdminResources extends StatefulWidget {
  const AdminResources({super.key});

  @override
  State<AdminResources> createState() => _AdminResourcesState();
}
class _AdminResourcesState extends State<AdminResources> {
  String? selectedProgram;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProgramProvider(
            FetchPrograms(ProgramRepositoryImpl(FirebaseFirestore.instance)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BatchProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (_) => SectionProvider(FirebaseFirestore.instance),
        ),
      ],
      child: Scaffold(
        body: Consumer<ProgramProvider>(
          builder: (context, programProvider, child) {
            if (programProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
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

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Header(title: ' Resources'),
                    const SizedBox(height: 20),
                    Row( children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 130,
                          decoration: kMediumBoxDecoration.copyWith(color: secondaryColor),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Container(width: 0),
                              value: selectedProgram,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedProgram = newValue;
                                });
                              },
                              items: programProvider.programs.map((Program program) {
                                return DropdownMenuItem<String>(
                                  value: program.name,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(program.name, style: kMediumColoredTextStyle,),
                                      ),
                                      kLargeHorizontalSpace,
                                      Icon(Icons.circle, color: program.color,)
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Display batches for the selected program
                    FutureBuilder<List<Batch>>(
                      future: Provider.of<BatchProvider>(context, listen: false).getBatchesByProgramId(selectedProgramObj?.id ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        List<Batch>? batches = snapshot.data;

                        if (batches == null || batches.isEmpty) {
                          return Text('No batches found for the selected program');
                        }

                        // Display the list of batches
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: batches.map((batch) {
                            return  Padding(
                                padding:const EdgeInsets.all(16.0) ,
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: kMediumBoxDecoration.copyWith(color: secondaryColor),
                              width: 70,

                              child: Text(batch!.year.toString(),style: kLargeColoredBoldTextStyle,),
                            ));
                          }).toList(),
                        );
                      },
                    ),
                      ]
                    )
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