import 'package:chatapp/chats_screen.dart';
import 'package:chatapp/freinds_screen.dart';
import 'package:chatapp/people_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageController = TextEditingController();
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friemds',
          ),
        ],
        selectedItemColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    switch (selectedIndex) {
      case 0:
        return _buildChats();
      case 1:
        return _buildPeople();
      case 2:
        return _buildGroups();
      default:
        return _buildChats();
    }
  }

  Widget _buildChats() {
    return ChatsScreen();
  }

  Widget _buildPeople() {
    return PeopleScreen();
  }

  Widget _buildGroups() {
    return FriendsScreen();
  }
}
