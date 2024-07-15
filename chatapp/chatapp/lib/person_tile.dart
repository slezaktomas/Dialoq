import 'package:chatapp/people_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/person_tile.dart';

class PersonTile extends StatefulWidget {
  final String loginUserId;
  final String personId;
  final String personEmail;
  final String personName;

  PersonTile({
    required this.loginUserId,
    required this.personId,
    required this.personEmail,
    required this.personName,
  });

  @override
  _PersonTileState createState() => _PersonTileState();
}

class _PersonTileState extends State<PersonTile> {
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
        .doc(widget.personId)
        .collection('requests')
        .doc(widget.loginUserId)
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
      trailing: isFriend
          ? Text('Request Sent')
          : IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.personId)
                    .collection('requests')
                    .doc(widget.loginUserId)
                    .set({
                  'email': FirebaseAuth.instance.currentUser?.email ?? '',
                  'name': currentUserName,
                });
                checkIfFriendExists();
                setState(() {
                  requestSent = true;
                });
              }),
      leading: CircleAvatar(
        child: Text(widget.personName[0]),
      ),
      title: Text(widget.personName),
      subtitle: Text(widget.personEmail),
    );
  }
}
