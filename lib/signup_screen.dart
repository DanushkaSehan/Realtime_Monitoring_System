import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'color_utils.dart';
import 'reset_password.dart';
import 'reusable_widget.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _roleTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              // hexStringToColor("#240638"),
              // hexStringToColor("#200b72"),
              // hexStringToColor("#5500cc")
              Color.fromARGB(255, 37, 0, 76),
              Color.fromARGB(255, 45, 1, 91),
              Color.fromARGB(255, 61, 14, 111),
              Color.fromARGB(255, 65, 11, 123),
              Color.fromARGB(255, 66, 0, 137),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter UserName", Icons.person_outline,
                      false, _userNameTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Email Id", Icons.person_outline,
                      false, _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outlined, true,
                      _passwordTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Role", Icons.workspaces_outline,
                      true, _roleTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  forgetPassword(context),
                  firebaseUIButton(context, "Sign Up", () async {
                    try {
                      final String userName =
                          _userNameTextController.text.trim();
                      final String email = _emailTextController.text.trim();
                      final String password =
                          _passwordTextController.text.trim();
                      final String role = _roleTextController.text.trim();
                      // Create user in Firebase Authentication
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);

                      // Get the user's UID
                      String uid = userCredential.user!.uid;

                      // Create a user document in Firestore
                      await _firestore.collection('users').doc(uid).set({
                        'userName': userName,
                        'email': email,
                        'role': role,
                      });
                      _showSnackBar("Sign up successful",
                          Color.fromARGB(255, 1, 217, 29));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    } catch (e) {
                      // Handle errors (e.g., display an error message)
                      print("Error during sign-up: $e");
                      _showSnackBar("Error during sign-up", Colors.red);
                    }
                  })
                ],
              ),
            ))),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}
