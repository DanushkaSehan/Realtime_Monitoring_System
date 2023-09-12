// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'background_widget.dart'; // Import the BackgroundWidget file

// class RealTimeDataScreen extends StatefulWidget {
//   const RealTimeDataScreen({super.key});

//   @override
//   _RealTimeDataScreenState createState() => _RealTimeDataScreenState();
// }

// class _RealTimeDataScreenState extends State<RealTimeDataScreen> {
//   final reference = FirebaseDatabase.instance.ref('Device 01');

//   Widget _buildDataCard(String title, String data, Color color, double height) {
//     return Card(
//       elevation: 8,
//       margin: EdgeInsets.all(10),
//       color: color,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(40.0),
//       ),
//       child: Container(
//         padding: EdgeInsets.all(20),
//         width: 300,
//         height: height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueGrey.shade100),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             Text(
//               data,
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent, // Set background to transparent
//       body: SafeArea(
//         child: Stack(
//           children: [
//             BackgroundWidget(), // Add BackgroundWidget here
//             StreamBuilder(
//               stream: reference.child('lastUpdatedGroup').onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData && snapshot.data != null) {
//                   DataSnapshot dataSnapshot = snapshot.data!.snapshot;
//                   if (dataSnapshot.value != null && dataSnapshot.value is Map) {
//                     Map<dynamic, dynamic> dataMap =
//                         dataSnapshot.value as Map<dynamic, dynamic>;

//                     int? groupKey = dataMap['groupKey'] as int?;
//                     int? encoder1Data = dataMap['Input'] as int?;
//                     int? encoder2Data = dataMap['Output'] as int?;

//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               _buildDataCard(
//                                 'Fabric:',
//                                 'Group $groupKey',
//                                 Colors.indigo.shade800,
//                                 105,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 70), // Added more space
//                           Column(
//                             children: [
//                               _buildDataCard(
//                                 'Input Length',
//                                 '$encoder1Data cm',
//                                 Colors.deepPurpleAccent,
//                                 105,
//                               ),
//                               SizedBox(height: 20), // Added more space
//                               _buildDataCard(
//                                 'Output Length',
//                                 '$encoder2Data cm',
//                                 Colors.deepPurpleAccent,
//                                 105,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return const Center(
//                       child: Text('No data available'),
//                     );
//                   }
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealTimeDataScreen extends StatefulWidget {
  const RealTimeDataScreen({super.key});

  @override
  _RealTimeDataScreenState createState() => _RealTimeDataScreenState();
}

class _RealTimeDataScreenState extends State<RealTimeDataScreen> {
  final reference = FirebaseDatabase.instance.ref('Device 01');

  Widget _buildDataCard(String title, String data, Color color, double height) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(10),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        width: 300,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade100),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              data,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(43, 105, 104, 104),
      body: StreamBuilder(
        stream: reference.child('lastUpdatedGroup').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            if (dataSnapshot.value != null && dataSnapshot.value is Map) {
              Map<dynamic, dynamic> dataMap =
                  dataSnapshot.value as Map<dynamic, dynamic>;

              int? groupKey = dataMap['groupKey'] as int?;
              int? encoder1Data = dataMap['Input'] as int?;
              int? encoder2Data = dataMap['Output'] as int?;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDataCard(
                          'Fabric:',
                          'Group $groupKey',
                          Colors.indigo.shade800,
                          105,
                        ),
                      ],
                    ),
                    SizedBox(height: 70), // Added more space
                    Column(
                      children: [
                        _buildDataCard(
                          'Input Length',
                          '$encoder1Data cm',
                          Colors.deepPurpleAccent,
                          105,
                        ),
                        SizedBox(height: 20), // Added more space
                        _buildDataCard(
                          'Output Length',
                          '$encoder2Data cm',
                          Colors.deepPurpleAccent,
                          105,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
