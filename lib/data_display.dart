import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'daywise_data.dart';
import 'realtime_data.dart'; // Import your real-time data screen

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const RealTimeDataScreen(), // Real-time Data Screen
    const DayWiseDataScreen(), // Day-wise Data Screen
    //WeekWiseDataScreen(), // Week-wise Data Screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Image.asset(
          'assets/images/FabriTrack logo.png',
          width: 90,
          height: 90,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CupertinoSlidingSegmentedControl(
              children: const {
                0: Text('Real-Time Data'),
                1: Text('Day-wise Data'),
                //2: Text('Week-wise Data'),
              },
              onValueChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentIndex = newValue;
                  });
                }
              },
              groupValue: _currentIndex,
            ),
          ),
          Expanded(
            child: _children[_currentIndex],
          ),
        ],
      ),
    );
  }
}
