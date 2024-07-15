import 'package:chatapp/friend_tile.dart';
import 'package:chatapp/people_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/person_tile.dart';
import 'package:chatapp/request_tile.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    final loginUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(loginUserId)
                  .collection('requests')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No requests available'));
                }
                final people = snapshot.data!.docs;
                List<Widget> peopleWidgets = [];
                for (var person in people) {
                  final personData = person.data() as Map<String, dynamic>;
                  final personEmail = personData['email'];
                  final personName = personData['name'];
                  final personId = person.id;

                  final personWidget = RequestTile(
                    loginUserId: loginUserId,
                    personId: personId,
                    personEmail: personEmail,
                    personName: personName,
                  );
                  peopleWidgets.add(personWidget);
                }
                return Expanded(
                  child: ListView(
                    children: peopleWidgets,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
