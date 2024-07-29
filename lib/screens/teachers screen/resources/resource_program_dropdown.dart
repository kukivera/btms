import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../admin screens/programs/components/program_model.dart';
import '../../admin screens/programs/components/provider.dart';

class ProgramDropdownContainer extends StatelessWidget {
  final Program? selectedProgram;
  final ValueChanged<Program?> onChanged;

  const ProgramDropdownContainer({
    Key? key,
    required this.selectedProgram,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramProvider>(
      builder: (context, programProvider, child) {
        if (programProvider.isLoading) {
          return CircularProgressIndicator();
        }

        if (programProvider.errorMessage != null) {
          return Text('Error: ${programProvider.errorMessage}');
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            decoration: kBasicBoxDecoration.copyWith(
              color: secondaryColor,
            ),
            width: 150,
            child: DropdownButtonFormField<Program>(
              autofocus: true,
              icon: Icon(
                Icons.circle,
                color: selectedProgram?.color ?? Colors.transparent,
              ),
              focusColor: primaryColor,
              borderRadius: BorderRadius.circular(20),
              dropdownColor: Colors.white,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              value: selectedProgram ?? (programProvider.programs.isNotEmpty ? programProvider.programs.first : null),
              onChanged: onChanged,
              items: programProvider.programs.map((Program program) {
                return DropdownMenuItem<Program>(
                  value: program,
                  child: Text(
                    program.name,
                    style: kMediumColoredTextStyle,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}