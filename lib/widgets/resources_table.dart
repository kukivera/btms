import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


import '../responsive.dart';

class ProgramTable extends StatefulWidget {
  @override
  _ProgramTableState createState() => _ProgramTableState();
}

class _ProgramTableState extends State<ProgramTable> {
  List<Map<String, dynamic>> _tableData = [
    {
      'Program': 'Program A',
      'Batch': 'Batch 1',
      'Courses': 'Course 1, Course 2',
      'Attachment': null,
      'Attached By': 'John Doe',
    },
    {
      'Program': 'Program B',
      'Batch': 'Batch 2',
      'Courses': 'Course 3, Course 4',
      'Attachment': null,
      'Attached By': 'Jane Smith',
    },
    {
      'Program': 'Program C',
      'Batch': 'Batch 3',
      'Courses': 'Course 5, Course 6',
      'Attachment': null,
      'Attached By': 'Bob Johnson',
    },
  ];

  Future<void> _attachFile(int index) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _tableData[index]['Attachment'] = result.files.single.name;
      });
    }
  }

  void _viewFile(int index) {
    // Implement the logic to view the file
    print('Viewing file: ${_tableData[index]['Attachment']}');
  }

  void _deleteFile(int index) {
    // Implement the logic to delete the file
    setState(() {
      _tableData[index]['Attachment'] = null;
    });
    print('Deleting file: ${_tableData[index]['Attachment']}');
  }

  void _downloadFile(int index) {
    // Implement the logic to download the file
    print('Downloading file: ${_tableData[index]['Attachment']}');
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
            label: Text('Program', style: TextStyle(color: Colors.black))),
        if (Responsive.isDesktop(context))
          DataColumn(
              label: Text('Batch', style: TextStyle(color: Colors.black))),
        DataColumn(
            label: Text('Courses', style: TextStyle(color: Colors.black))),
        DataColumn(
            label: Text('Attachment', style: TextStyle(color: Colors.black))),
        if (Responsive.isDesktop(context))
          DataColumn(
              label:
                  Text('Attached By', style: TextStyle(color: Colors.black))),
      ],
      rows: _tableData
          .map((data) => DataRow(
                cells: [
                  DataCell(Text(
                    data['Program'],
                    style: TextStyle(color: Colors.black),
                  )),
                  if (Responsive.isDesktop(context))
                    DataCell(Text(data['Batch'],
                        style: TextStyle(color: Colors.black))),
                  DataCell(Text(data['Courses'],
                      style: TextStyle(color: Colors.black))),
                  DataCell(
                    Row(
                      children: [
                        if (data['Attachment'] != null)
                          InkWell(
                            onTap: () => _viewFile(_tableData.indexOf(data)),
                            child: Icon(
                              Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        SizedBox(width: 8),
                        if (data['Attachment'] != null)
                          InkWell(
                            onTap: () => _deleteFile(_tableData.indexOf(data)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () => _attachFile(_tableData.indexOf(data)),
                          child: Icon(
                            Icons.upload,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (data['Attachment'] != null)
                          InkWell(
                            onTap: () => _downloadFile(_tableData.indexOf(data)),
                            child: Icon(
                              Icons.download,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (Responsive.isDesktop(context))
                    DataCell(Text(data['Attached By'],
                        style: TextStyle(color: Colors.black))),
                ],
              ))
          .toList(),
    );
  }
}