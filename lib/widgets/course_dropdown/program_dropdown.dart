import 'package:flutter/material.dart';

class ProgramDropdown extends StatefulWidget {
  const ProgramDropdown({super.key});

  @override
  ProgramDropdownState createState() => ProgramDropdownState();
}

class ProgramDropdownState extends State<ProgramDropdown> {
  String? _selectedProgram;
  String? _selectedBatch;
  String? _selectedSection;
  String? _selectedCourse;

  final List<String> _program = ['CII Certificate', 'CII Diploma', 'CISI'];

  final Map<String, List<String>> _batches = {
    'CII Certificate': ['2023', '2024'],
    'CII Diploma': ['2024'],
    'CISI': ['2023', '2024', ],
  };

  final Map<String, List<String>> _sections = {
    'CII Certificate': ['Section I', 'Section II', 'Section III'],
    'CII Diploma': ['Section X', 'Section Y', 'Section Z'],
    'CISI': ['Section Alpha', 'Section Beta', 'Section Gamma'],
  };

  final Map<String, List<String>> _classes = {
    'CII Certificate': ['(W01) Award in General Insurance', '(WCE) Insurance claims handling (nonUK)', '(WUE) Insurance underwriting (nonUK)'],
    'CII Diploma': ['Class 1B', 'Class 2B', 'Class 3B'],
    'CISI': ['Class 1C', 'Class 2C', 'Class 3C'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          style: const TextStyle(color: Colors.black),
          value: _selectedProgram,
          items: _program.map((String course) {
            return DropdownMenuItem<String>(
              value: course,
              child: Text(
                course,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedProgram = value;
              _selectedBatch = null;
              _selectedSection = null;
              _selectedCourse = null;
            });
          },
          hint: const Text(
            'Select Program',
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(height: 10),
        if (_selectedProgram != null)
          Row(
            children: [
              _buildDropdown('Batch', _selectedBatch, _batches[_selectedProgram!], (String? value) {
                setState(() {
                  _selectedBatch = value;
                  _selectedSection = null;
                  _selectedCourse = null;
                });
              }),
              SizedBox(width: 10),
              _buildDropdown('Section', _selectedSection, _sections[_selectedProgram!], (String? value) {
                setState(() {
                  _selectedSection = value;
                  _selectedCourse = null;
                });
              }),
              SizedBox(width: 10),
              _buildDropdown('Course', _selectedCourse, _classes[_selectedProgram!], (String? value) {
                setState(() {
                  _selectedCourse = value;
                });
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String>? items, Function(String?) onChanged) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        style: TextStyle(color: Colors.black),
        value: value,
        items: items?.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList() ?? [],
        onChanged: onChanged,
        hint: Text(
          'Select $label',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}