import 'package:chatapp/friend_tile.dart';
import 'package:chatapp/people_screen.dart';
import 'package:chatapp/request_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/person_tile.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    final loginUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('Pending Requests'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestScreen()),
                  );
                },
              ),
            ),
            Divider(),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(loginUserId)
                  .collection('friends')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final people = snapshot.data!.docs;
                List<Widget> peopleWidgets = [];
                for (var person in people) {
                  final personData = person.data() as Map<String, dynamic>;
                  final personEmail = personData['email'];
                  final personName = personData['name'];
                  final personId = person.id;

                  final personWidget = FriendTile(
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
