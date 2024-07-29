import 'package:flutter/material.dart';
import 'package:bruh_finance_tms/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bruh_finance_tms/screens/admin%20screens/profile/venue/components/services.dart';

class VenueSelectionCard extends StatelessWidget {
  final VenueModel venue;
  final VenueService venueService = VenueService();

  VenueSelectionCard({Key? key, required this.venue}) : super(key: key);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          title: Text('Delete Venue'),
          content: Text('Are you sure you want to delete this venue?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await venueService.deleteVenue(venue.venueName);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Venue deleted successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final TextEditingController nameController =
    TextEditingController(text: venue.venueName);
    final TextEditingController urlController =
    TextEditingController(text: venue.url);
    final TextEditingController addressController =
    TextEditingController(text: venue.address);
    final TextEditingController telephoneController =
    TextEditingController(text: venue.telephone);
    final TextEditingController seatController =
    TextEditingController(text: venue.number_of_seat);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          title: Text('Update Venue'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Venue Name'),
                ),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: 'URL'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: telephoneController,
                  decoration: InputDecoration(labelText: 'Telephone'),
                ),
                TextField(
                  controller: seatController,
                  decoration: InputDecoration(labelText: 'Number of Seats'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                Navigator.of(context).pop();
                await venueService.updateVenue(
                  venue.venueName,
                  nameController.text,
                  urlController.text,
                  addressController.text,
                  telephoneController.text,
                  seatController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Venue updated successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              venue.venueName,
              style: kLargeColoredBoldTextStyle,
            ),
            kMediumVerticalSpace,
            const CircleAvatar(
              backgroundColor: primaryColor,
              radius: 50,
              child: Icon(
                Icons.location_on_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            kMediumVerticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: primaryColor),
                  onPressed: () => _showUpdateDialog(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: primaryColor),
                  onPressed: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
