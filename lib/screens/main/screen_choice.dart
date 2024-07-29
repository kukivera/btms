import 'dart:js';

import 'package:bruh_finance_tms/screens/admin%20screens/payment/invoice.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/profile/venue/venueProfile.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/programs/schedule_and_assign/schedule_and_Assign.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/registration/student/Registration%20choice.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/registration/student/student%20database/Student_database.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/registration/student/student%20registation/student_registration.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/registration/teacher/Registration%20choice.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/registration/teacher/teacher%20registartion/teachers_registration.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/registration/teacher/teachers%20database/teacher_database.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/resources/resources.dart';
import 'package:bruh_finance_tms/screens/login/login_page.dart';
import 'package:bruh_finance_tms/screens/students%20screens/examBooking/exam_booking_screen.dart';
import 'package:bruh_finance_tms/screens/teachers%20screen/attendance/components/tutors_attendance.dart';
import 'package:bruh_finance_tms/screens/teachers%20screen/schedule/tutors_schedule.dart';
import 'package:flutter/material.dart';
import 'package:bruh_finance_tms/screens/students%20screens/examBooking/new_Exam_Booking.dart';
import 'package:bruh_finance_tms/screens/students%20screens/rating/new_rating.dart';
import 'package:bruh_finance_tms/screens/students%20screens/schedule/new_schedule.dart';
import 'package:bruh_finance_tms/screens/teachers%20screen/grading/grades.dart';
import 'package:bruh_finance_tms/screens/teachers%20screen/myRatings/myRatings.dart';
import 'package:bruh_finance_tms/widgets/addAttendance/teachers_attendance.dart';
import 'package:provider/provider.dart';
import '../../controllers/screen_provider.dart';
import '../../widgets/ProgramCard/cardTrial.dart';
import '../admin screens/AdminExamBooking/admin_exam_booking.dart';
import '../admin screens/admin_dashboard/admin_dashboard.dart';
import '../admin screens/payment/payment.dart';
import '../admin screens/profile/courseProfile/course_profile.dart';
import '../admin screens/profile/profiles.dart';
import '../admin screens/profile/sponsor/sponsersProfile.dart';
import '../admin screens/programs/programs.dart';

import '../admin screens/result/result.dart';
import '../students screens/dashboard/dashboard_screen.dart';
import '../students screens/paymentDetails/details.dart';
import '../students screens/paymentDetails/hi.dart';
import '../teachers screen/TeachersDashboard/teachers_dashboard.dart';
import '../teachers screen/resources/resources_screen.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/programs/program_batch_section_provider.dart';



Widget buildSelectedScreen(BuildContext context) {

  return Consumer<SelectedScreenProvider>(
    builder: (context, selectedScreenProvider, child) {

      final selectedScreen = selectedScreenProvider.selectedScreen;
      switch (selectedScreen) {

        case 'AdminHome':
          return const AdminDashboard();




// admin Dashboard
        case 'Schedules':
          return const NewSchedule();
        case 'AdminDashboard':
          return const AdminDashboard();
        case 'StudentRegistration' :
          return const StudentRegistrationChoice();
        case 'StudentDatabase' :
          return const StudentDatabase();
        case 'StudentRegistrationForm' :
          return const StudentRegistrationForm();
        case 'TeacherRegistrationChoice' :
          return const TeacherRegistrationChoice();
        case 'TeacherRegistrationForm' :
          return const TeacherRegistrationForm();
        case 'TeacherDatabase' :
          return const TeacherDatabase();
        case 'Resources' :
          return const AdminResources();
        case 'AdminBookingDate':
          return const BookingDate();
        case 'login' :
          return const Login();



        case 'Profile' :
          return const AllProfiles();
        case 'Programs':
          return  Programs();

        case 'ExamResult':
          return const ExamResult();

          // profiles
          case 'SponsorProfile':
          return const SponsorProfiles();
          case 'CourseProfile':
          return const  CourseProfiles();
        case  'VenueProfile':
          return const VenueProfile();




        case 'Payment':
          return const InvoiceGenerator();
        // case 'StudentRegistration':
        //   return StudentRegistrationForm();

        case 'TeachersAttendance':
          return const AttendanceTable();
        // case 'TeachersRegistration':
        //   return TeacherRegistrationForm();
        case 'ProgCard':
          return const ProgCard();


        //students
        case 'Home':
          return const DashboardScreen();
        case 'StudentSchedulePage':
          return const Hi();
        case 'StudentsPaymentDetailsPage':
          return const StudentPaymentDetails();
        case 'BookExams':
          return const NewExamBooking();
        case 'StudentsTeacherRating':
          return RatingApp();


        //Teachers
        case 'TeachersDashboard':
          return const TeachersDashboard1();
        case 'TeacherSchedule':
          return const TutorsSchedule();
        case 'GradesRecorder':
          return const GradesRecorder();
        case 'TeachersAttendanceRecorder':
          return const TutorsAttendance();
        case 'MyRating':
          return const MyRatings();
        case 'ResourcesPage':
          return const ResourcesPage();
        default:
          return Container(); // Return some default screen or error screen
      }
    },
  );
}
