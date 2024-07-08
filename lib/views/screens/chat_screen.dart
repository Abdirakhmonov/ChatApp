import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../controllers/chat_controller.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/push_notification.dart';

class ChatScreen extends StatefulWidget {
  User1 user;

  ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final chatcontroller = ChatController();
  final _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      chatcontroller.sendMessage(
          widget.user.id, _messageController.text, widget.user.userName);
      FirebasePushNotificationService.sendNotificationMessage(
          widget.user.token, widget.user.userName, _messageController.text);
      _messageController.clear();
    }
  }

  void sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final image =  chatcontroller.sendImageMessage(
          widget.user.id, imageFile, widget.user.userName);
      FirebasePushNotificationService.sendNotificationImage(
          widget.user.token, widget.user.userName, image);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatcontroller.getMessages(
                  widget.user.id, _firebaseAuth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error occurred"),
                  );
                }
                final data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final message = Message.fromJson(data[index]);
                    var alignment =
                        (message.senderId == _firebaseAuth.currentUser!.uid);
                    return Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: alignment
                            ? MediaQuery.of(context).size.width / 2.5
                            : 10,
                        right: !alignment
                            ? MediaQuery.of(context).size.width / 2.5
                            : 10,
                      ),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomRight: !alignment
                              ? const Radius.circular(20)
                              : Radius.zero,
                          bottomLeft: alignment
                              ? const Radius.circular(20)
                              : Radius.zero,
                        ),
                        color: alignment ? Colors.green : Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: message.message.startsWith('http')
                            ? Image.network(message.message)
                            : Text(
                                message.message,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: sendImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
