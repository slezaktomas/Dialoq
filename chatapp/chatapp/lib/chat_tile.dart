import 'package:chatapp/chat_screen.dart';
import 'package:chatapp/people_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/person_tile.dart';

class ChatTile extends StatefulWidget {
  final String loginUserId;
  final String chatId;
  final Map<String, dynamic> chatData;
  final QuerySnapshot membersSnapshot;

  ChatTile({
    required this.loginUserId,
    required this.chatId,
    required this.chatData,
    required this.membersSnapshot,
  });

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isFriend = false;
  bool requestSent = false;
  String currentUserName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final secondMemberDoc = widget.membersSnapshot.docs
        .firstWhere((doc) => doc.id != widget.loginUserId);

    Map<String, dynamic>? data =
        secondMemberDoc.data() as Map<String, dynamic>?;
    String personName = data?['person_name'] ?? 'unknown name';
    String personId = data?['person_id'] ?? 'unknown id';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              personName: personName,
              personId: personId,
              chatId: widget.chatId,
            ),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(personName[0]),
        ),
        title: Text(personName),
      ),
    );
  }
}
