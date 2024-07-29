import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';
import 'components/program_model.dart';
import 'dialoge_service.dart';
import 'components/batch_model.dart';
import 'components/sectionModel.dart';





class AddProgramContainer extends StatelessWidget {
  final VoidCallback onAddProgram;

  const AddProgramContainer({required this.onAddProgram, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: onAddProgram,
      child: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: MaterialStateColor.resolveWith((states) => primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '+ New Program',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// program_container.dart

class ProgramContainer extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isTapped;

  const ProgramContainer({
    required this.program,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.isTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 100,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                boxShadow: isTapped
                    ? [
                  BoxShadow(
                    color: primaryColor,
                    offset: Offset(8.0, 5.0),
                  ),
                ]
                    : [],
                color: secondaryColor, // Replace with your secondaryColor
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: program.color, size: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          program.name,
                          style: kLargeColoredBoldTextStyle, // Replace with your kLargeColoredBoldTextStyle
                        ),
                      ),
                      SizedBox(height: 8), // Replace with your kMediumVerticalSpace
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue), // Replace with your primaryColor
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outlined, color: Colors.blue), // Replace with your primaryColor
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BatchContainer extends StatelessWidget {
  final Batch batch;
  final Function(String) onDelete;
  final VoidCallback onTap;
  final String programId;
  final bool isTapped;

  const BatchContainer({
    required this.batch,
    required this.onDelete,
    required this.programId,
    required this.onTap,
    required this.isTapped,
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8.0),
      boxShadow: isTapped
          ? [
          const BoxShadow(
          color: primaryColor,
          offset: Offset(8.0, 5.0),
        ),
        ]
        : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              batch.year.toString(),
              style: kLargeColoredBoldTextStyle,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: primaryColor,
              ),
              onPressed: () {
                DialogService.showDeleteConfirmationDialog(
                  context: context,
                  itemId: batch.id,
                  title: 'Delete Batch',
                  deleteFunction: (id) async {
                    await onDelete(batch.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class SectionContainer extends StatelessWidget {
  final Section section;
  final Function(String) onDelete;
  final VoidCallback onTap;
  final bool sectionIsTapped;


  const SectionContainer({
    super.key,
    required this.section,
    required this.onDelete,
    required this.onTap, required this.sectionIsTapped,


  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,

        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: sectionIsTapped
            ? [
          const BoxShadow(
            color: primaryColor,
            offset: Offset(8.0, 5.0),
          ),
        ]
            : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              section.name,
              style: kMediumColoredTextStyle,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                DialogService.showDeleteConfirmationDialog(
                  context: context,
                  itemId: section.id,
                  title: 'Delete Section',
                  deleteFunction: (id) async {
                    await onDelete(section.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}