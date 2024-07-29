import 'package:flutter/material.dart';

import '../../../constants.dart';

class RegistrationTextField extends StatelessWidget {
  const RegistrationTextField({
    super.key,
    required this.textController,
    required this.title,
    required this.maxLength,
  });

  final TextEditingController textController;
  final String title;
  final int  maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      child: TextField(
        style: kMediumColoredTextStyle,
        controller: textController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: title,
          hintStyle: const TextStyle(color: primaryColor, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
