import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/chat_tile.dart';

class ChatsScreen extends StatelessWidget {
  final String loginUserId = FirebaseAuth.instance.currentUser!.uid;

  ChatsScreen();

  Future<Widget?> getChatTile(
      String chatId, String loginUserId, dynamic chatData) async {
    try {
      QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .collection("members")
          .get();

      if (membersSnapshot.docs.map((doc) => doc.id).contains(loginUserId)) {
        print("chatId: $chatId");
        return ChatTile(
          loginUserId: loginUserId,
          chatId: chatId,
          chatData: chatData,
          membersSnapshot: membersSnapshot,
        );
      }
    } catch (e) {
      print("Error fetching members: $e");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("chats").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No chats available'));
        }

        final chats = snapshot.data!.docs;

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chatData = chats[index].data();
            final chatId = chats[index].id;

            return FutureBuilder<Widget?>(
              future: getChatTile(chatId, loginUserId, chatData),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return snapshot.data!;
                }
                return SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }
}
