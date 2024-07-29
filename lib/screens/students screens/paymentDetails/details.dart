
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../constants.dart';
import '../../../widgets/header.dart';
import 'components/innvoice_to_constructor.dart';
import 'components/invoice_from_constructor.dart';
import 'detailTable.dart';


class StudentPaymentDetails extends StatefulWidget {
  const StudentPaymentDetails({super.key});

  @override
  State<StudentPaymentDetails> createState() => _StudentPaymentDetailsState();
}

class _StudentPaymentDetailsState extends State<StudentPaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Header(title: 'Invoice'),
          ),
          Center(
            child: Container(
              height: 500,
              width: 900,
              color: secondaryColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              "assets/images/logo.png",
                              color: Colors.lightBlueAccent,
                              height: 100,
                              width: 100,
                            ),
                          ),

                          // SizedBox(height: 10),
                           Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InvoiceToDetail(),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InvoiceFromDetail(),
                      )
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 22),
                        child: Text(
                          "Date: April 20,2024",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(height: 200, child: ClassDetailTableMain()),
                      Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child: Container(
                          height:25,
                          width: 150,
                          decoration:kBasicBoxDecoration,
                          child: const Center(
                            child: Text(
                              "Total Amount: 300,000ETB",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 95),
            child: Container(
              height: 40,
              width: 100,
              decoration:kBasicBoxDecoration,
              child: Center(
                child: Text("Print"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
