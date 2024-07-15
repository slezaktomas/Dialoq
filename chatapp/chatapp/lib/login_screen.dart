import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final Email = TextEditingController();
    final Password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: Email,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextField(
              controller: Password,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: Email.text,
                    password: Password.text,
                  );
                  print('Successfully logged in');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  } else {
                    print('Failed to log in: $e');
                  }
                } catch (e) {
                  print('Failed to log in: $e');
                }
              },
              child: Text('Log in'),
            )
          ],
        ),
      ),
    );
  }
}
