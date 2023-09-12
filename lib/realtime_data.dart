import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealTimeDataScreen extends StatefulWidget {
  const RealTimeDataScreen({super.key});

  @override
  _RealTimeDataScreenState createState() => _RealTimeDataScreenState();
}

class _RealTimeDataScreenState extends State<RealTimeDataScreen> {
  final reference = FirebaseDatabase.instance.ref('Device 01');

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
                    Text(
                      'Fabric : ${groupKey ?? 0}',
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Input Length    : ' '${encoder1Data ?? 0} cm',
                      style: const TextStyle(fontSize: 25),
                    ),
                    Text(
                      'Output Length : ${encoder2Data ?? 0} cm',
                      style: const TextStyle(fontSize: 25),
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
