

import 'package:bruh_finance_tms/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../controllers/user_provider.dart';

import 'dart:html' as html; // Import dart:html

class ProfileDialog extends StatelessWidget {
  final UserProvider userProvider;

  const ProfileDialog({Key? key, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController(text: userProvider.firstName);
    final TextEditingController lastNameController = TextEditingController(text: userProvider.lastName);
    final TextEditingController phoneNumberController = TextEditingController(text: userProvider.phoneNumber);

    Future<void> updateProfile() async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'phoneNumber': phoneNumberController.text,
            'imageUrl': userProvider.imageUrl,
          });

          userProvider.setUser(
            uid: user.uid,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneNumberController.text,
            role: userProvider.role!, // Keep the role the same
            imageUrl: userProvider.imageUrl !,
          );

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: secondaryColor,
                title: const Text('Success', style: kMediumColoredTextStyle),
                content: const Text('Profile updated successfully', style: kMediumColoredTextStyle),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK', style: kMediumColoredTextStyle),
                  ),
                ],
              );
            },
          );
        } catch (error) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: secondaryColor,
                title: const Text('Error', style: kMediumColoredTextStyle),
                content: Text('Failed to update profile: $error', style: kMediumColoredTextStyle),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK', style: kMediumColoredTextStyle),
                  ),
                ],
              );
            },
          );
        }
      }
    }

    Future<void> updateProfilePicture() async {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) async {
        final file = uploadInput.files?.first;
        if (file != null) {
          final reader = html.FileReader();

          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) async {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              try {
                final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${user.uid}');
                final uploadTask = storageRef.putBlob(file);
                final snapshot = await uploadTask;
                final downloadUrl = await snapshot.ref.getDownloadURL();

                await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                  'imageUrl': downloadUrl,
                });

                userProvider.setUser(
                  uid: user.uid,
                  firstName: userProvider.firstName!,
                  lastName: userProvider.lastName!,
                  phoneNumber: userProvider.phoneNumber!,
                  role: userProvider.role !, // Keep the role the same
                  imageUrl: downloadUrl,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile picture updated successfully')),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update profile picture: $error')),
                );
              }
            }
          });
        }
      });
    }

    return AlertDialog(
      backgroundColor: secondaryColor,
      title: const Text('Profile', style: kMediumColoredTextStyle),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: updateProfilePicture,
              child: CircleAvatar(
                backgroundImage: userProvider.imageUrl != null
                    ? NetworkImage(userProvider.imageUrl!)
                    : const AssetImage("assets/images/profile_pic.png") as ImageProvider,
                radius: 50,
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
            Text(
              'Role: ${userProvider.role}', // Display the role
              style: kMediumColoredTextStyle,
            ),
            TextField(
              style: kMediumColoredTextStyle,
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: kMediumColoredTextStyle,
              ),
            ),
            TextField(
              style: kMediumColoredTextStyle,
              controller: lastNameController,
              decoration: const InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: kMediumColoredTextStyle),
            ),
            TextField(
              style: kMediumColoredTextStyle,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: kMediumColoredTextStyle,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ChangePasswordDialog();
                  },
                );
              },
              child: const Text('Change Password', style: kWhiteText),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: kMediumColoredTextStyle),
        ),
        TextButton(
          onPressed: updateProfile,
          child: const Text('Save', style: kMediumColoredTextStyle),
        ),
      ],
    );
  }
}



// change password conversation
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();



  void changePassword(String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Reauthenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        await EasyLoading.showSuccess('Password updated successfully');
        Navigator.of(context).pop();
      } catch (error) {
        await EasyLoading.showError('Error: $error');
      }
    }
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Text('Confirm Password Change', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to change your password?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                changePassword(currentPasswordController.text, newPasswordController.text);
              },
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      title: const Text('Change Password', style: kMediumColoredTextStyle,),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              style: kMediumColoredTextStyle,
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password',
                labelStyle: kMediumColoredTextStyle,
              ),
              obscureText: true,
            ),
            TextField(
              style: kMediumColoredTextStyle,
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password',
                labelStyle: kMediumColoredTextStyle,
              ),
              obscureText: true,
            ),
            TextField(
              style: kMediumColoredTextStyle,
              controller: confirmNewPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm New Password',
                labelStyle: kMediumColoredTextStyle,
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel',style: kWhiteText,),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => primaryColor)
          ),
          onPressed: () {
            if (newPasswordController.text == confirmNewPasswordController.text) {
              showConfirmationDialog();
            } else {
              EasyLoading.showError('New passwords do not match');
            }
          },
          child: const Text('Change Password',style: kWhiteText,),
        ),
      ],
    );
  }
}



