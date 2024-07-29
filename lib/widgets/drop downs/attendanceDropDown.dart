import 'package:flutter/material.dart';
//
// class Program {
//   final String name;
//   final List<Batch> batches;
//   final Color color;
//
//   Program(this.name, this.batches, this.color);
// }

// class Batch {
//   final int year;
//   final List<Section> sections;
//
//   Batch(this.year, this.sections);
// }
//
// class Section {
//   final String name;
//   final List<String> courses;
//
//   Section(this.name, this.courses);
// }
//
// class AttendanceCourseSelectionDropdown extends StatefulWidget {
//   const AttendanceCourseSelectionDropdown({Key? key}) : super(key: key);
//
//   @override
//   State<AttendanceCourseSelectionDropdown> createState() =>
//       _AttendanceCourseSelectionDropdownState();
// }
//
// class _AttendanceCourseSelectionDropdownState extends State<AttendanceCourseSelectionDropdown> {
// //   List<Program> programs = [
// //     Program(
// //       'CII',
// //       [
// //         Batch(2023, [
// //           Section('Morning', ['WO1', 'WCE', 'WUE']),
// //           Section('Afternoon', ['WO1', 'WCE', 'WUE'])
// //         ]),
// //         Batch(2024, [
// //           Section('Morning', ['WO1', 'WCE', 'WUE']),
// //           Section('Afternoon', ['WO1', 'WCE', 'WUE'])
// //         ]),
// //       ],
// //       Colors.blue,
// //     ),
// //     Program(
// //       'CII D',
// //       [
// //         Batch(2023, [
// //           Section('Morning', ['Course X', 'Course Y']),
// //           Section('Afternoon', ['Course X', 'Course Y'])
// //         ]),
// //         Batch(2024, [
// //           Section('Morning', ['Course A', 'Course B']),
// //           Section('Afternoon', ['Course A', 'Course B'])
// //         ]),
// //       ],
//       Colors.orange,
//     ),
//     Program(
//       'CISI',
//       [
//         Batch(2023, [
//           Section('Morning', ['Course Alpha']),
//           Section('Afternoon', ['Course Alpha'])
//         ]),
//         Batch(2024, [
//           Section('Morning', ['Course Beta']),
//           Section('Afternoon', ['Course Beta'])
//         ]),
//       ],
//       Colors.green,
//     ),
//   ];
//
//   List<String> selectedCourses = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             for (var program in programs)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 8),
//                     buildBatchDropdown(program),
//                     const SizedBox(height: 8),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//         Row(
//           children: selectedCourses
//               .map(
//                 (course) => Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ButtonStyle(
//                   backgroundColor:
//                   MaterialStateProperty.all<Color>(Colors.grey),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     course,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           )
//               .toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget buildBatchDropdown(Program program) {
//     return Container(
//       width: 100,
//       padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
//       decoration: BoxDecoration(
//         color: program.color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonFormField<Batch>(
//         hint: Text(
//           program.name,
//           style: TextStyle(color: Colors.white),
//         ),
//         icon: Icon(
//           Icons.circle,
//           color: Colors.white,
//         ),
//         value: null,
//         decoration: const InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.transparent),
//           ),
//         ),
//         dropdownColor: Colors.white,
//         onChanged: (batch) {
//           setState(() {
//             selectedCourses = batch!.sections
//                 .expand((section) => section.courses)
//                 .toList();
//           });
//         },
//         items: program.batches.map((batch) {
//           return DropdownMenuItem<Batch>(
//             value: batch,
//             child: Text(
//               batch.year.toString(),
//               style: const TextStyle(color: Colors.black),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
