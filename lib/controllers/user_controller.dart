
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../services/firebase_auth_service.dart';

class UserController {
  final _userAuthentication = UserAuthService();

  Future<void> registerUser(String email, String password, String username,
      BuildContext context) async {
    await _userAuthentication.registerUser(context, email, password, username);
  }

  void logInUser(String email, String password) async {
    _userAuthentication.logInUser(email, password);
  }

  void resetPasswordUser(String email) async {
    _userAuthentication.resetPasswordUser(email);
  }

  void signOut() async {
    _userAuthentication.signOut();
  }

  Stream<QuerySnapshot> getAllUsers() async* {
    yield* _userAuthentication.getAllUsers();
  }
}
