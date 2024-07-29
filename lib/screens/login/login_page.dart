

import 'package:bruh_finance_tms/screens/main/admin_main_screen.dart';
import 'package:bruh_finance_tms/screens/main/teacher_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/user_provider.dart';
import '../../responsive.dart';
import '../main/main_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Responsive.isMobile(context)
                ? const SizedBox()
                : Expanded(
              flex: 3,
              child: Container(
                height: height,
                color: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      scale: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(30.0),
                color: bgColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            kLargeVerticalSpace,
                            kLargeVerticalSpace,
                            RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                    text: ' Log In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      fontSize: 25.0,
                                    )),
                              ]),
                            ),
                            SizedBox(height: height * 0.02),
                            const Text(
                                'Hello! Please enter your information to login ',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w100,
                                    color: primaryColor)),
                            SizedBox(height: height * 0.064),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Container(
                              height: 50.0,
                              width: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: secondaryColor,
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor.withOpacity(0.5),
                                  fontSize: 12.0,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.email,
                                      color: primaryColor,
                                      size: 15,
                                    ),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.only(top: 16.0),
                                  hintText: 'Enter Email',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor.withOpacity(0.5),
                                    fontSize: 12.0,
                                  ),
                                  fillColor: secondaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.014),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Container(
                              height: 50.0,
                              width: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: secondaryColor,
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor.withOpacity(0.5),
                                  fontSize: 12.0,
                                ),
                                obscureText: !passwordVisible,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      !passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: primaryColor,
                                      size: 15,
                                    ),
                                  ),
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.lock,
                                      color: primaryColor,
                                      size: 15,
                                    ),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.only(top: 16.0),
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor.withOpacity(0.5),
                                    fontSize: 12.0,
                                  ),
                                  fillColor: secondaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot Password?',
                                  style: kMediumColoredTextStyle,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            Material(
                              color: const Color(0x00000000),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () async {
                                    // Basic validation
                                    if (email.isEmpty || password.isEmpty) {
                                      await EasyLoading.showError(
                                          "Email and password cannot be empty.");
                                      return;
                                    }

                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(email)) {
                                      await EasyLoading.showError(
                                          "Invalid email format.");
                                      return;
                                    }

                                    try {
                                      final credential = await FirebaseAuth
                                          .instance.signInWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                                      // Show success message
                                      await EasyLoading.showSuccess(
                                          "Logged in successfully!");

                                      // Navigate to the main screen after successful login
                                      route(context);
                                    } on FirebaseAuthException catch (e) {
                                      await EasyLoading.showError(
                                          '${e.message}');
                                      // Log the error code for debugging
                                      print('FirebaseAuthException code: ${e
                                          .code}');

                                      switch (e.code) {
                                        case 'user-not-found':
                                          print(
                                              'No user found for that email.');
                                          await EasyLoading.showError(
                                              "No user found for that email.");
                                          break;
                                        case 'wrong-password':
                                          print(
                                              'Wrong password provided for that user.');
                                          await EasyLoading.showError(
                                              "Wrong password provided for that user.");
                                          break;
                                        default:
                                          print(
                                              'Unhandled FirebaseAuthException: ${e
                                                  .code}');
                                          await EasyLoading.showError(
                                              "Password or Email Incorrect");
                                          break;
                                      }
                                    } catch (e) {
                                      print('Error: $e');
                                      await EasyLoading.showError(
                                          "An unexpected error occurred. Please try again.");
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Ink(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Responsive.isDesktop(context)
                                          ? 30.0
                                          : 20.0,
                                      vertical: 18.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: primaryColor,
                                    ),
                                    child: const Text('Sign In', style: SignIn),
                                  ),
                                ),
                              ),


                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> route(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<
              String,
              dynamic>;
          String role = data['role'];
          String firstName = data['firstName'];
          String lastName = data['lastName'];
          String imageUrl = data['imageUrl'];
          String phoneNumber = data['phoneNumber'];
          String email = data['email'];

          String? additionalId;
          bool additionalDataExists = false;

          // Fetch additional ID based on role and email
          if (role == "teacher" || role == "student") {
            String collection = role == "teacher" ? 'teachers' : 'students';

            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection(collection)
                .where('email', isEqualTo: email)
                .limit(1)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              DocumentSnapshot additionalDocSnapshot = querySnapshot.docs.first;
              additionalId = additionalDocSnapshot.id;
              additionalDataExists = true;
            } else {
              print(
                  'Additional document does not exist in the database'); // Debug log
            }
          }

          if (role == "teacher" || role == "student") {
            if (!additionalDataExists) {
              await EasyLoading.showError(
                  'Additional data not found in the database.');
              return; // Exit the function if the additional data is not found
            }
          }

          // Accessing the UserProvider and updating it
          final userProvider = Provider.of<UserProvider>(
              context, listen: false);
          userProvider.setUser(
            uid: user.uid,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            role: role,
            imageUrl: imageUrl,
            additionalId: additionalId, // Set the additional ID
          );

          Widget targetScreen;
          if (role == "student") {
            targetScreen = const MainScreen();
          } else if (role == "teacher") {
            targetScreen = const TeacherMainScreen();
          } else if (role == "admin") {
            targetScreen = const AdminMainScreen();
          } else {
            targetScreen = const MainScreen();
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MenuAppController(),
                      ),
                      ChangeNotifierProvider.value(value: userProvider),
                    ],
                    child: targetScreen,
                  ),
            ),
          );
        } else {
          await EasyLoading.showError('User data not found in the database.');
          print('Document does not exist in the database');
        }
      } catch (error) {
        await EasyLoading.showError('Error fetching user role: $error');
        print('Error fetching user role: $error');
      }
    } else {
      await EasyLoading.showError('No user is currently signed in.');
      print('No user signed in');
    }
  }
}
  const SignIn = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.white,
  fontSize: 12.0,
);
