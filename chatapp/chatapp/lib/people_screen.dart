import 'package:chatapp/people_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/person_tile.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final messageController = TextEditingController();
  bool requestSent = false;
  bool isFriend = false;
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> people = [];
    final loginUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    final loginUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

                void checkIfFriendExists() async {
                  final docSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(loginUserId)
                      .collection('requests')
                      .doc(personId)
                      .get();

                  if (docSnapshot.exists) {
                    setState(() {
                      print("already friend");
                      isFriend = true;
                    });
                  } else {
                    setState(() {
                      print("not friend");
                      isFriend = false;
                    });
                  }
                }

                if (personEmail != loginUserEmail) {
                  final personWidget = PersonTile(
                    loginUserId: loginUserId,
                    personId: personId,
                    personEmail: personEmail,
                    personName: personName,
                  );
                  peopleWidgets.add(personWidget);
                }
              }
              return Expanded(
                child: ListView(
                  children: peopleWidgets,
                ),
              );
            },
          )
        ]),
      ),
    );
  }
}
