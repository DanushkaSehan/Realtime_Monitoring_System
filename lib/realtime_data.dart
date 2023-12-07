import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'background_widget.dart';

class RealTimeDataScreen extends StatefulWidget {
  const RealTimeDataScreen({Key? key}) : super(key: key);

  @override
  _RealTimeDataScreenState createState() => _RealTimeDataScreenState();
}

class _RealTimeDataScreenState extends State<RealTimeDataScreen> {
  final reference = FirebaseDatabase.instance.reference().child('Device 01');
  Color containerColor = Color.fromARGB(150, 34, 42, 149);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(),
          Center(
            child: StreamBuilder(
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

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Perform action for Fabric button
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(150, 255, 255, 255),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Fabric: ${groupKey ?? 0}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Perform action for Input Length button
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Input Length',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue.shade50,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                  ),
                                ),
                                //const SizedBox(height: 10),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Perform action for Encoder Data for Input Length button
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      '${encoder1Data ?? 0} cm',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue.shade50,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Perform action for Output Length button
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Output Length',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue.shade50,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                  ),
                                ),
                                //const SizedBox(height: 10),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Perform action for Encoder Data for Output Length button
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      '${encoder2Data ?? 0} cm',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue.shade50,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No data available',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
