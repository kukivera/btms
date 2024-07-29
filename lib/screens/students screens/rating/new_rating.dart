
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constants.dart';
import '../../../widgets/header.dart';


class RatingApp extends StatefulWidget {
  @override
  _RatingAppState createState() => _RatingAppState();
}

class _RatingAppState extends State<RatingApp> {
  int _currentQuestionIndex = 0;
  int _selectedRating = 0;
  String? _selectedTeacher;

  final List<String> _teachers = [
    'Mr. Biniyam Getachew',
    'Mr. Abebe Getachew',
    'Mr. Kebede Getachew'
  ];

  final List<String> _questions = [
    'On a scale of 1 to 5, how would you rate the clarity of the teacher\'s explanations during class?',
    'How well did the teacher manage the classroom environment?',
    'How engaging and interactive were the lessons?',
    // Add more questions here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Header(title: 'Rating'),
        ), // Header outside the SingleChildScrollView
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rate your tutor by selecting their profile and answering the provided questions.',
                          style: TextStyle(fontSize: 16, color: primaryColor),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _teachers
                                .map(
                                  (teacher) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTeacher = teacher;
                                    _currentQuestionIndex =
                                    0; // Reset the question index
                                    _selectedRating = 0; // Reset the selected rating
                                  });
                                },
                                child: _buildTeacherCard(teacher),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 32),
                        _selectedTeacher == null
                            ? SizedBox() // Don't display anything if no teacher is selected
                            : _buildQuestionCard(),
                        SizedBox(height: 16),
                        _selectedTeacher == null
                            ? SizedBox() // Don't display buttons if no teacher is selected
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _currentQuestionIndex == 0
                                  ? null
                                  : () {
                                setState(() {
                                  _currentQuestionIndex--;
                                  _selectedRating =
                                  0; // Reset the selected rating
                                });
                              },
                              child: Text(
                                'Prev',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _currentQuestionIndex ==
                                  _questions.length - 1
                                  ? null
                                  : () {
                                setState(() {
                                  _currentQuestionIndex++;
                                  _selectedRating =
                                  0; // Reset the selected rating
                                });
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _selectedTeacher == null
                            ? SizedBox() // Don't display the submit button if no teacher is selected
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Handle submit action here
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }
  Widget _buildQuestionCard() {
    return Container(
      height: 300,
      width: 800,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question #${_currentQuestionIndex + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _questions[_currentQuestionIndex],
            style: TextStyle(color: primaryColor),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = index + 1;
                  });
                },
                child: Container(
                  width: 40,
                  height: 30,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _selectedRating == index + 1
                        ? primaryColor
                        : secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _selectedRating == index + 1
                        ? [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _selectedRating == index + 1
                            ? Colors.white
                            : primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTeacherCard(String teacher) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _selectedTeacher == teacher
            ? [
          BoxShadow(
            color: secondaryColor,
            offset: Offset(0, 6),
            blurRadius: 8,
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(),
          Text(
            teacher,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
          ),
          SizedBox(height: 8),
          Column(
            children: [
              Row(
                children: [
                  _buildRatingCircle(primaryColor),
                  SizedBox(width: 8),
                  Text(
                    "Woi",
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildRatingCircle(primaryColor),
                  SizedBox(width: 8),
                  Text(
                    "URI",
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildRatingCircle(primaryColor),
                  SizedBox(width: 8),
                  Text(
                    "Co1",
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCircle(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }




}


