
import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
  String id;
  String email;
  String userName;
  String photoUrl;
  String token;
  User1({
    required this.id,
    required this.token,
    required this.email,
    required this.userName,
    required this.photoUrl,
  });

  factory User1.fromJson(QueryDocumentSnapshot snap) {
    return User1(
      id: snap.id,
      token:snap['token'],
      email: snap["email"],
      userName: snap['userName'],
      photoUrl: snap['photoUrl'],
    );
  }
}
