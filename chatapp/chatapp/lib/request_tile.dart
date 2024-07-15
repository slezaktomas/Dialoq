import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestTile extends StatefulWidget {
  final String loginUserId;
  final String personId;
  final String personEmail;
  final String personName;

  RequestTile({
    required this.loginUserId,
    required this.personId,
    required this.personEmail,
    required this.personName,
  });

  @override
  _RequestTileState createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  bool isFriend = false;
  bool requestSent = false;
  String currentUserName = '';

  @override
  void initState() {
    super.initState();
    checkIfFriendExists();
    fetchCurrentUserDetails();
  }

  void checkIfFriendExists() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loginUserId)
        .collection('requests')
        .doc(widget.personId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        isFriend = true;
      });
    } else {
      setState(() {
        isFriend = false;
      });
    }
  }

  void createChatRoom() async {
    print("chat was created");

    /*FirebaseFirestore.instance.collection('chats').doc(chatRoomRef.id).set({
      'chat_room_id': chatRoomRef.id,
      'person_id': widget.personId,
      'created_at': FieldValue.serverTimestamp(),
    });

    FirebaseFirestore.instance.collection('chats').doc(chatRoomRef.id).set({
      'chat_room_id': chatRoomRef.id,
      'person_id': widget.loginUserId,
      'created_at': FieldValue.serverTimestamp(),
    });*/
  }

  void fetchCurrentUserDetails() async {
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loginUserId)
        .get();

    if (currentUserDoc.exists) {
      setState(() {
        currentUserName = currentUserDoc.data()?['name'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.loginUserId)
                    .collection('requests')
                    .doc(widget.personId)
                    .delete();

                setState(() {
                  requestSent = true;
                });
                Duration(seconds: 1);
              }),
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.green,
              ),
              onPressed: () {
                final chatDocId =
                    FirebaseFirestore.instance.collection('chats').doc().id;
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.loginUserId)
                    .collection('friends')
                    .doc(widget.personId)
                    .set({
                  'email': widget.personEmail,
                  'name': widget.personName,
                });
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.personId)
                    .collection('friends')
                    .doc(widget.loginUserId)
                    .set({
                  'email': FirebaseAuth.instance.currentUser?.email ?? '',
                  'name': currentUserName,
                });
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatDocId)
                    .set({});

                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatDocId)
                    .collection("members")
                    .doc(widget.personId)
                    .set({
                  'person_id': widget.personId,
                  'person_name': widget.personName,
                });
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatDocId)
                    .collection("members")
                    .doc(widget.loginUserId)
                    .set({
                  'person_id': widget.loginUserId,
                  'person_name': currentUserName,
                });

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.loginUserId)
                    .collection('requests')
                    .doc(widget.personId)
                    .delete();
              }),
        ],
      ),
      leading: CircleAvatar(
        child: Text(widget.personName[0]),
      ),
      title: Text(widget.personName),
      subtitle: Text(widget.personEmail),
    );
  }
}
