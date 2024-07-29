import 'package:bruh_finance_tms/screens/admin%20screens/profile/sponsor/components/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bruh_finance_tms/screens/admin screens/profile/registration field.dart';
import '../../../../../constants.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  TextEditingController sponsorNameContorller = TextEditingController();
  TextEditingController institutionContorller = TextEditingController();
  TextEditingController addressContorller = TextEditingController();
  TextEditingController telephoneContorller = TextEditingController();
  TextEditingController emailContorller = TextEditingController();
  final sponsorService = SponsorService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 600,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: secondaryColor,
        ),
        child: SingleChildScrollView(
            child: Column(

              mainAxisSize: MainAxisSize.max,

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Sponsor',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'profile',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            RegistrationTextField(
              textController: sponsorNameContorller,
              title: 'Sponsor Name',
              maxLength: 200,
            ),
            kMediumVerticalSpace,
            RegistrationTextField(
              textController: institutionContorller,
              title: 'Institution',
              maxLength: 200,
            ),
            kMediumVerticalSpace,
            RegistrationTextField(
              textController: addressContorller,
              title: 'Address',
              maxLength: 200,
            ),
            kMediumVerticalSpace,
            RegistrationTextField(
              textController: telephoneContorller,
              title: 'Telephone',
              maxLength: 18,
            ),
            kMediumVerticalSpace,
            RegistrationTextField(
              textController: emailContorller,
              title: 'Email',
              maxLength: 200,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await sponsorService.addSponsor(
                      sponsorName: sponsorNameContorller.text,
                      institution: institutionContorller.text,
                      address: addressContorller.text,
                      telephone: telephoneContorller.text,
                      email: emailContorller.text,
                    );
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sponsor registered successfully!')),
                    );
                    Navigator.of(context).pop(); // Close the modal
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error registering sponsor: $e')),
                    );
                  }
                  // Close the modal after pressing add
                },
                child: Text('Add'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
