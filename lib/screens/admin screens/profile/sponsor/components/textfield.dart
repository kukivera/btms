import 'package:flutter/material.dart';
import '../../../../../constants.dart';

class RegistrationTextField extends StatelessWidget {
  const RegistrationTextField({
    super.key,
    required this.textController,
    required this.title,
  });

  final TextEditingController textController;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryColor,
          hintText: title,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}