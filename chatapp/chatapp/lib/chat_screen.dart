import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String personName;
  final String personId;
  final String chatId;

  ChatScreen({
    required this.personName,
    required this.personId,
    required this.chatId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .doc(widget.chatId)
                      .collection("messages")
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final messages = snapshot.data!.docs;
                    List<Widget> messageWidgets = [];
                    for (var message in messages) {
                      final messageData =
                          message.data() as Map<String, dynamic>;
                      final messageText = messageData['message'];
                      final messageSender = messageData['sender_id'];

                      final messageWidget = messageSender ==
                              FirebaseAuth.instance.currentUser?.uid
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, top: 3),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Delete Message?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection("chats")
                                                          .doc(widget.chatId)
                                                          .collection(
                                                              "messages")
                                                          .doc(message.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF32cf5a),
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 8.0),
                                          child: Text(
                                            messageText,
                                            maxLines: 9999999999,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 3),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 8.0),
                                          child: Text(
                                            messageText,
                                            maxLines: 9999999999,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )));

                      messageWidgets.add(messageWidget);
                    }
                    return Column(
                      children: messageWidgets,
                    );
                  },
                ),
              ]),
            ),
            BottomAppBar(
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 99999,
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc(widget.chatId)
                            .collection("messages")
                            .doc()
                            .set({
                          'sender_id': FirebaseAuth.instance.currentUser?.uid,
                          'receiver_id': widget.personId,
                          'message': message.text,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        message.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
