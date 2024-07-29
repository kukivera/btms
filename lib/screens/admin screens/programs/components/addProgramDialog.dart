import 'package:bruh_finance_tms/constants.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/programs/components/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'program_model.dart';

class AddProgramDialog extends StatefulWidget {
  final Function(Program) onProgramAdded;

  const AddProgramDialog({super.key, required this.onProgramAdded});

  @override
  _AddProgramDialogState createState() => _AddProgramDialogState();
}

class _AddProgramDialogState extends State<AddProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String institute = '';
  String creditHour = '';
  String description = '';
  String preRequest = '';
  String fee = '';
  String category = 'Financial';
  Color selectedColor = Colors.blue;

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      title: const Text('Add Program'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Program Name',
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a program name';
                  } else if (value.length > 4) {
                    return 'Name cannot be more than four letters';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Institute',
                  labelStyle: kMediumWhiteTextStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    institute = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an institute';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Credit Hour',
                  labelStyle: kMediumWhiteTextStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    creditHour = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credit hours';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: kMediumWhiteTextStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pre Request',
                  labelStyle: kMediumWhiteTextStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    preRequest = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pre-requests';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Fee',
                  labelStyle: kMediumWhiteTextStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    fee = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fee';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Color>(
                decoration: const InputDecoration(
                  labelText: 'Color',
                  labelStyle: kMediumWhiteTextStyle,
                ),
                value: selectedColor,
                onChanged: (Color? newValue) {
                  setState(() {
                    selectedColor = newValue!;
                  });
                },
                items: colors.map((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: color,
                    ),
                  );
                }).toList(),
              ),
              RadioListTile<String>(
                title: const Text('Financial'),
                value: 'Financial',
                groupValue: category,
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('General'),
                value: 'General',
                groupValue: category,
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              var newProgram = Program(
                id: '', // You can set the appropriate ID here if needed
                name: name,
                institute: institute,
                creditHour: creditHour,
                description: description,
                preRequest: preRequest,
                category: category,
                color: selectedColor,
                fee: fee,
              );

              ProgramService().addProgram(newProgram);
              widget.onProgramAdded(newProgram);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
