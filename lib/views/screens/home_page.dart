import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../models/user.dart';
import '../../services/firebase_auth_service.dart';
import 'chat_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       CupertinoPageRoute(
        //         builder: (context) => const ProfileScreen(),
        //       ),
        //     );
        //   },
        //   icon: const Icon(Icons.person),
        // ),
        actions: [
          IconButton(
              onPressed: () {
                UserAuthService().signOut();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: _userController.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            const Center(
              child: Text("Error bor"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
          }
          final data = snapshot.data!.docs;
          return data.isEmpty
              ? const Center(
                  child: Text("Apida malumot yoq"),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        height: 10,
                      ),
                    );
                  },
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final user = User1.fromJson(data[index]);
                    return user.id == FirebaseAuth.instance.currentUser!.uid
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => ChatScreen(
                                    user: user,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                // onBackgroundImageError: (exception, stackTrace) {
                                //   const Icon(Icons.person);
                                // },
                                radius: 30,
                                backgroundImage: NetworkImage(user.photoUrl),
                              ),
                              title: Text(user.userName),
                            ),
                          );
                  },
                );
        },
      ),
    );
  }
}
