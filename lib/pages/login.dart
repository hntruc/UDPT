import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supper_vip_pro_poll_flutter_mobile_cross_platform/pages/poll.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String error = 'Hi';
  bool isError = false;

  Future login() async {
    // FirebaseAuth.instance.signOut();
    // return;

    try {
      setState(() => {isError = false});
      UserCredential res =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text.toString(),
        password: passwordController.text.toString(),
      ));
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        print('Wrong email.');
        errorMessage = 'Wrong email.';
      } else {
        errorMessage = 'Please input username and password.';
      }
      setState(() {
        isError = true;
        error = errorMessage;
      });
    } catch (e) {
      //print('E' + e.toString());
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VotingPoll()),
      );
    } else {
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
                controller: usernameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  controller: passwordController,
                  obscureText: true),
            ),
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  foregroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: login,
                child: Text('Login')),
            Visibility(visible: isError, child: Text(error))
          ],
        )));
  }
}
