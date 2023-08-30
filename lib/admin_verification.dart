import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iotrealtimedatameasure/signup_screen.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  _AdminVerificationScreenState createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  final TextEditingController _adminUsernameController =
      TextEditingController();
  final TextEditingController _adminPasswordController =
      TextEditingController();

  Future<void> _verifyAdmin(BuildContext context) async {
    final enteredUsername = _adminUsernameController.text;
    final enteredPassword = _adminPasswordController.text;

    try {
      // Query Firestore to check admin credentials
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('Admin')
          // .where('username', isEqualTo: enteredUsername)
          .get()
          .then((snapshot) => snapshot.docs.forEach((document) async {
                if (enteredUsername == document.reference.id) {
                  print('user verifired');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                  //     await FirebaseFirestore.instance
                  // .collection('Admin').doc(enteredUsername.toString()).get()
                }
              }));

      // if (adminSnapshot == 1) {
      //   final adminData = adminSnapshot.docs[0].data();
      //   if (adminData['password'] == enteredPassword) {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => SignUpScreen()),
      //     );
      //   } else {
      //     _showAlertDialog(context, "Wrong Password");
      //   }
      // } else {
      //   _showAlertDialog(context, "Admin username not found.");
      // }
    } catch (e) {
      _showAlertDialog(context, "Error verifying admin credentials");
      print("Error verifying admin credentials: $e");
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Verification"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _adminUsernameController,
            decoration: const InputDecoration(labelText: "Admin Username"),
          ),
          TextField(
            controller: _adminPasswordController,
            decoration: const InputDecoration(labelText: "Admin Password"),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              _verifyAdmin(context);
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }
}
