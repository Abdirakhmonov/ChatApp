import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../services/chat_service.dart';

class ChatController {
  final _chatService = ChatService();

  void sendMessage(String toUserId, String message, String userName) {
    _chatService.sendMessage(toUserId, message, userName);
  }

  void sendImageMessage(String toUserId, File imageFile, String userName) {
    _chatService.sendImageMessage(toUserId, imageFile, userName);
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) async* {
    yield* _chatService.getMessages(userId, otherUserId);
  }
}
