import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        elevation: 20,
        shadowColor: Color.fromARGB(255, 59, 33, 102),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Row(
          children: [
            Image.asset(
              'assets/images/FabriTrack logo.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 130),
            Flexible(
              child: Container(
                child: Text(
                  'Track'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Text('Real-Time Data'.tr),
                1: Text('Day-Wise Data'.tr),
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
