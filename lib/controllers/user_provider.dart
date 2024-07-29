import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  String? uid;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? role;
  String? imageUrl;
  String? additionalId;

  void setUser({
    required String uid,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String role,
    required String imageUrl,
    String? additionalId,
  }) {
    this.uid = uid;
    this.firstName = firstName;
    this.lastName = lastName;
    this.phoneNumber = phoneNumber;
    this.role = role;
    this.imageUrl = imageUrl;
    this.additionalId = additionalId;
    notifyListeners();
  }
}