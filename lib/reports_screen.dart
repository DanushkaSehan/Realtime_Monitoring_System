import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'background_widget.dart';
import 'downtime_screen.dart';
import 'efficiency_screen.dart';
import 'maintenancereport_screen.dart';
import 'workedhours_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 18, 19, 26),
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
                  'Reports'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        //title: Text('Filtered Day Wise Data'),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 150),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DownTimeScreen()),
                    );
                  },
                  icon: const Icon(Icons.area_chart_outlined),
                  label: Text('Down Time'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkedHourScreen()),
                    );
                  },
                  icon: const Icon(Icons.analytics_outlined),
                  label: Text('Worked Hours'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EfficiencyScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_chart),
                  label: Text('Efficiency'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaintenanceReportScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_ic_call),
                  label: Text('Maintenance Report'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
