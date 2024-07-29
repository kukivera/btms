
import 'package:bruh_finance_tms/screens/admin%20screens/programs/components/service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../constants.dart';
import 'program_model.dart';



// update program dialog
class UpdateProgramDialog extends StatefulWidget {
  final Program program;
  final Function(Program) onProgramUpdated;

  const UpdateProgramDialog({super.key, required this.program, required this.onProgramUpdated});

  @override
  UpdateProgramDialogState createState() => UpdateProgramDialogState();
}

class UpdateProgramDialogState extends State<UpdateProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String institute;
  late String creditHour;
  late String description;
  late String preRequest;
  late String category;
  late String fee;
  late Color selectedColor;

  final List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    name = widget.program.name;
    institute = widget.program.institute;
    creditHour = widget.program.creditHour;
    description = widget.program.description;
    preRequest = widget.program.preRequest;
    category = widget.program.category;
    fee = widget.program.fee;
    selectedColor = colors.contains(widget.program.color) ? widget.program.color : colors[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      title: const Text('Update Program'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
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
                initialValue: institute,
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Institute',
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
                initialValue: creditHour,
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Credit Hour',
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
                initialValue: description,
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Description',
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
                initialValue: preRequest,
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Pre Request',
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
                initialValue: fee,
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Fee',
                ),
                onChanged: (value) {
                  setState(() {
                    fee = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fee';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Color>(
                value: selectedColor,
                decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Color',
                ),
                onChanged: (Color? newValue) {
                  setState(() {
                    selectedColor = newValue!;
                  });
                },
                items: colors.map((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 18,
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              var updatedProgram = Program(
                id: widget.program.id,
                name: name,
                institute: institute,
                creditHour: creditHour,
                description: description,
                preRequest: preRequest,
                category: category,
                color: selectedColor,
                fee: fee,
              );

              try {
                await widget.onProgramUpdated(updatedProgram);
                print('Success: Program updated');
                Navigator.of(context).pop();
              } catch (error) {
                print('Error: $error');
              }
            } else {
              print('Form validation failed');
            }
          },
          child: const Text('Update'),
        ),

      ],
    );
  }
}


// deliting program function
class DeleteProgramDialog extends StatefulWidget {
  final String programId;
  final Function() onProgramDeleted;

  const DeleteProgramDialog({super.key, required this.programId, required this.onProgramDeleted});

  @override
  DeleteProgramDialogState createState() => DeleteProgramDialogState();
}

class DeleteProgramDialogState extends State<DeleteProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  String password = '';
  String? errorMessage;

  Future<void> _reauthenticateAndDelete() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          errorMessage = 'No user is currently signed in.';
        });
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await ProgramService().deleteProgram(widget.programId);
      widget.onProgramDeleted();
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        errorMessage = 'Error authenticating: $e';
      });
    }
  }


  // delete program dialog


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      title: const Text('Delete Program'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please re-enter your password to confirm.'),
            TextFormField(
              decoration: const InputDecoration(
                  labelStyle: kMediumWhiteTextStyle,
                  labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
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
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)
          ),
          onPressed: _reauthenticateAndDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
