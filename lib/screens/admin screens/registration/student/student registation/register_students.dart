import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';


class Mobile_view extends StatefulWidget {
  const Mobile_view({
    super.key,
  });

  @override
  State<Mobile_view> createState() => _Mobile_viewState();
}

class _Mobile_viewState extends State<Mobile_view> {

  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emergancyNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController paidByController = TextEditingController();
  TextEditingController instalmentController = TextEditingController();
  TextEditingController secondaryPhoneController = TextEditingController();
  TextEditingController secondaryEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: dobController,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor,
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor,
                hintText: 'Phone Number',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: emergancyNumberController,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor,
                hintText: 'Emeregency Contact',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor,
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: positionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor,
                hintText: 'Position',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: programController,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor,
                hintText: 'Program',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),


          SizedBox(height: 16),
          Column(
            children: [
              Container(
                height: 50,
                width: 350,
                child: TextField(
                  controller: paidByController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Paid By',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 50,
                width: 350,
                child: TextField(
                  controller: instalmentController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Instalment',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

            SizedBox(height: 16),
              Container(
                height: 50,
                width: 350,
                child: TextField(
                  controller: secondaryPhoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Secondary Email',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                height: 50,
                width: 350,
                child: TextField(
                  controller: secondaryPhoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Secondary Phone',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
