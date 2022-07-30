import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supper_vip_pro_poll_flutter_mobile_cross_platform/pages/poll.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  TextEditingController usernameController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  String errorText = '';
  bool isError = false;

  Future register() async {
    try {
      setState(() => {isError = false});
      UserCredential res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usernameController.text.toString(),
              password: passwordController.text.toString());
    } on FirebaseAuthException catch (error) {
      String errorMessage = '';
      if (error.code == 'email-already-in-use') {
        print('Email is already in use');
        errorMessage = 'Email is already in use';
      }
      setState(() {
        isError = true;
        errorText = errorMessage;
      });
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Is Logged in');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VotingPoll()),
      );
    } else {
      print('User is not logged in');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    super.dispose();
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
              padding: EdgeInsets.all(8.0),
              child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Username'),
                  controller: usernameController),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  controller: passwordController,
                  obscureText: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: register,
                    child: const Text('Register')),
                OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage(title: 'Login Page')),
                      );
                    },
                    child: const Text('Login')),
                OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Logout')),
              ],
            ),
            Visibility(visible: isError, child: Text(errorText))
          ],
        )));
  }
}
