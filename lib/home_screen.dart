import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addfabric_details.dart';
import 'data_display.dart'; // Import your real-time data screen
import 'maintenance_screen.dart';
import 'reports_screen.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? "";
  @override
  Widget build(BuildContext context) {
    if (currentUserUID == "v7GgJmld33eU5K16QSBF7kgFIK23") {
      // If the current user's UID matches, navigate to MaintenanceScreen
      return const MaintenanceScreen();
    } else {
      return Scaffold(
        //backgroundColor: Color.fromARGB(255, 18, 19, 26),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()));
                });
              },
            )
          ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FabricScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Fabric Details'),
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
                    MaterialPageRoute(builder: (context) => const DataScreen()),
                  );
                },
                icon: const Icon(Icons.account_tree_rounded),
                label: const Text('Real Time Tracking'),
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
                    MaterialPageRoute(builder: (context) => const ReportsScreen()),
                  );
                },
                icon: const Icon(Icons.add_chart),
                label: const Text('Reports'),
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
                label: const Text('Request Maintenance'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
