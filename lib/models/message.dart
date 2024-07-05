
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String senderId;
  String receiverId;
  String senderName;
  Timestamp timestamp;

  Message({
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "senderId": senderId,
      "receiverId": receiverId,
      "senderName": senderName,
      "timestamp": timestamp,
    };
  }

  factory Message.fromJson(QueryDocumentSnapshot snap) {
    return Message(
      message: snap['message'],
      receiverId: snap['receiverId'],
      senderId: snap['senderId'],
      senderName: snap['senderName'],
      timestamp: snap['timestamp'],
    );
  }
}
