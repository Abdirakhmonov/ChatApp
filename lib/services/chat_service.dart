import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/message.dart';

class ChatService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<void> sendMessage(
      String toUserId, String message, String userName) async {
    final currentUserId = _firebaseAuth.currentUser!.uid;

    final timestamp = Timestamp.now();

    Message newMessage = Message(
      message: message,
      receiverId: toUserId,
      senderId: currentUserId,
      senderName: userName,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, toUserId];
    ids.sort();
    String chatRoomID = ids.join("_");

    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .add(
          newMessage.toMap(),
        );
  }

  Future<void> sendImageMessage(
      String toUserId, File imageFile, String userName) async {
    final currentUserId = _firebaseAuth.currentUser!.uid;
    final timestamp = Timestamp.now();

    List<String> ids = [currentUserId, toUserId];
    ids.sort();
    String chatRoomID = ids.join("_");

    final storageRef = _firebaseStorage
        .ref()
        .child('chat_images')
        .child(chatRoomID)
        .child(timestamp.toString());

    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;
    final imageUrl = await snapshot.ref.getDownloadURL();

    Message newMessage = Message(
      message: imageUrl,
      receiverId: toUserId,
      senderId: currentUserId,
      senderName: userName,
      timestamp: timestamp,
    );

    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .add(
          newMessage.toMap(),
        );
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
