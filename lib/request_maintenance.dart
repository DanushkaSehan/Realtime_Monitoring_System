// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RequestMaintenanceScreen extends StatefulWidget {
//   @override
//   _RequestMaintenanceScreenState createState() =>
//       _RequestMaintenanceScreenState();
// }

// class _RequestMaintenanceScreenState extends State<RequestMaintenanceScreen> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   TextEditingController _issueController = TextEditingController();
//   TextEditingController _machineNumberController = TextEditingController();
//   bool _isUrgent = false;

//   void _submitMaintenanceRequest() async {
//     String uid = "v7GgJmld33eU5K16QSBF7kgFIK23"; // Target user's UID
//     String issue = _issueController.text;
//     String machineNumber = _machineNumberController.text;
//     String urgency = _isUrgent ? "Urgent" : "Normal";

//     String message = "$urgency\nMachine $machineNumber\n$issue";

//     // Retrieve user's device token from Firestore
//     String deviceToken = await _getDeviceToken(uid);

//     if (deviceToken != null) {
//       // Send message to the target user using Firebase Cloud Messaging
//       _firebaseMessaging.subscribeToTopic(uid); // Subscribe to the user's topic
//       _firebaseMessaging.send(
//         to: "/topics/$uid",
//         data: {
//           "title": "Maintenance Request",
//           "message": message,
//           "color": _isUrgent ? "red" : "default",
//         },
//       );
//     } else {
//       print("Device token not found for the user.");
//     }

//     // Clear text fields after submission
//     _issueController.clear();
//     _machineNumberController.clear();
//     _isUrgent = false;

//     // Show a confirmation dialog
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Request Submitted"),
//           content: Text("Your maintenance request has been submitted."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<String?> _getDeviceToken(String uid) async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection("YOUR_COLLECTION_NAME")
//           .doc(uid)
//           .get();
//       if (userDoc.exists) {
//         return userDoc.data()?["deviceToken"];
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("Error retrieving device token: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Maintenance"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _issueController,
//               decoration: InputDecoration(labelText: "Issue"),
//             ),
//             TextField(
//               controller: _machineNumberController,
//               decoration: InputDecoration(labelText: "Machine Number"),
//             ),
//             Row(
//               children: [
//                 Radio(
//                   value: true,
//                   groupValue: _isUrgent,
//                   onChanged: (value) {
//                     setState(() {
//                       _isUrgent = value;
//                     });
//                   },
//                 ),
//                 Text("Urgent"),
//                 Radio(
//                   value: false,
//                   groupValue: _isUrgent,
//                   onChanged: (value) {
//                     setState(() {
//                       _isUrgent = value;
//                     });
//                   },
//                 ),
//                 Text("Normal"),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: _submitMaintenanceRequest,
//               child: Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
