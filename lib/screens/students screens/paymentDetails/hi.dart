import 'dart:html';
import 'package:flutter/material.dart';



class Hi extends StatefulWidget {
  const Hi({super.key});

  @override
  _HiState createState() => _HiState();
}

class _HiState extends State<Hi> {
  String fileContent = '';

  void _readFile() {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.length == 1) {
        final file = files[0];
        final reader = FileReader();

        reader.onLoadEnd.listen((event) {
          setState(() {
            fileContent = reader.result as String;
          });
        });

        reader.readAsText(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Reader Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _readFile,
              child: Text('Select File'),
            ),
            SizedBox(height: 20),
            Text(
              'File Content:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  fileContent,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}