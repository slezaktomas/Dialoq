import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendTile extends StatefulWidget {
  final String loginUserId;
  final String personId;
  final String personEmail;
  final String personName;

  FriendTile({
    required this.loginUserId,
    required this.personId,
    required this.personEmail,
    required this.personName,
  });

  @override
  _FriendTileState createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  bool isFriend = false;
  bool requestSent = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Friend'),
                    content:
                        Text('Are you sure you want to delete this friend?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.personId)
                              .collection('friends')
                              .doc(widget.loginUserId)
                              .delete();
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.loginUserId)
                              .collection('friends')
                              .doc(widget.personId)
                              .delete();
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
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
