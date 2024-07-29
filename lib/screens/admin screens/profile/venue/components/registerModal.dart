
import 'package:bruh_finance_tms/screens/admin%20screens/profile/venue/components/services.dart';


import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../registration/student/student registation/services.dart';

import '../../sponsor/components/textfield.dart';


class VenueRegisterModal extends StatefulWidget {
  const VenueRegisterModal({super.key});

  @override
  State<VenueRegisterModal> createState() => _VenueRegisterModalState();
}

class _VenueRegisterModalState extends State<VenueRegisterModal> {


  final FirebaseService _firebaseService = FirebaseService();

  TextEditingController venueNameContorller = TextEditingController();
  TextEditingController urlContorller = TextEditingController();
  TextEditingController addressContorller = TextEditingController();
  TextEditingController telephoneContorller = TextEditingController();
  TextEditingController noOfSeatsContorller = TextEditingController();


  final venueService = VenueService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondaryColor,
      ),
      child:  Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Venue',
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
                textController: venueNameContorller,
                title: 'Venue Name',
              ),

              RegistrationTextField(
                textController: urlContorller,
                title: 'Copy Location Url',
              ),

              RegistrationTextField(
                textController: addressContorller,
                title: 'Address',
              ),

              RegistrationTextField(
                textController: telephoneContorller,
                title: 'Telephone',
              ),
              RegistrationTextField(
                textController: noOfSeatsContorller,
                title: 'No. of Seats',
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(

                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                          (states) => primaryColor,
                    ),
                  ),

                  onPressed: () async {
                    try {
                      await venueService.addVenue(
                        venueName: venueNameContorller.text,
                        url: urlContorller.text,
                        address: addressContorller.text,
                        telephone: telephoneContorller.text,
                        number_of_seat: noOfSeatsContorller.text,
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
                        SnackBar(
                            content: Text('Error registering sponsor: $e')),
                      );
                    }
                    // Close the modal after pressing add
                  },
                  child: Text('Add',style: kWhiteText,),
                ),
              ),
            ],
          ),

    );
  }
}
