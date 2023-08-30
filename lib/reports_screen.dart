import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 150),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 80),
                  backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => FabricScreen()),
                // );
              },
              icon: const Icon(Icons.area_chart_outlined),
              label: const Text('Down Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 80),
                  backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkedhourScreen()),
                );
              },
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Worked Hours'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 80),
                  backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => WorkedhourScreen()),
                // );
              },
              icon: const Icon(Icons.add_chart),
              label: const Text('Efficiency'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 80),
                  backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => RequestMaintenanceScreen()),
                // );
              },
              icon: const Icon(Icons.add_ic_call),
              label: const Text('Maintenance Report'),
            ),
          ],
        ),
      ),
    );
  }
}
