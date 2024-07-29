import 'dart:ui';

import 'package:flutter/material.dart';

// main colors start
const primaryColor = Color(0xFF11B3D7);
const secondaryColor =  Color(0xffd2f1f7);
const buttonColor = Color(0xFF14768D);

const primaryColorDark = Colors.blueGrey;
const secondaryColorDark= Colors.black;
const buttonColorDark = Colors.white;

//main colors end

const bgColor = Colors.white;
const textColor = Colors.black;


const defaultPadding = 16.0;
const kTextStyle = TextStyle(
  fontSize: 10,
  color: primaryColor,
  fontWeight: FontWeight.w500,
);

// text start
const kSmallTextStyle = TextStyle(
  fontSize: 8,
  color: Colors.black
);
const kSmallColorTextStyle = TextStyle(
    fontSize: 8,
    color: primaryColor,
);


const kWhiteText = TextStyle(
    color: Colors.white
);




const kMediumTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black
);

const kMediumColoredTextStyle = TextStyle(
    fontSize: 12,
    color: primaryColor,
);
const kMediumWhiteTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
);

const kMediumBoldTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w600,
);
const kMediumColoredBoldTextStyle = TextStyle(
    fontSize: 12,
    color: primaryColor,
   fontWeight: FontWeight.w500,

);



const kLargeColoredBoldTextStyle = TextStyle(
  fontSize: 18,
  color: primaryColor,
  fontWeight: FontWeight.w500,

);
const kLargeTextStyle = TextStyle(
    fontSize: 25,
    color: Colors.black
);

const kLargeColoredTextStyle = TextStyle(
  fontSize: 25,
  color: primaryColor
);



const kSmallHorizontalSpace = SizedBox(
  width: 10,
);
const kTextFieldVerticalSpace = SizedBox(height: 16);
const kMediumHorizontalSpace = SizedBox(
  width: 20,
);
const kLargeHorizontalSpace = SizedBox(
  width: 40,
);


const kSmallVerticalSpace = SizedBox(
  height: 10,
);
const kMediumVerticalSpace = SizedBox(
  height: 20,
);
const kLargeVerticalSpace = SizedBox(
  height: 40,
);

// text end

const kRegularPadding =  EdgeInsets.all(10.0);


const kBasicBoxDecoration =  BoxDecoration(
color: secondaryColor,
borderRadius: BorderRadius.all(Radius.circular(10)));


const kMediumBoxDecoration =  BoxDecoration(
color: secondaryColor,
    borderRadius: BorderRadius.all(Radius.circular(20)));


const kMediumWhiteBoxDecoration =  BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(20)));