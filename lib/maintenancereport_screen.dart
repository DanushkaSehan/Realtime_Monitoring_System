import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MaintenanceReportScreen extends StatefulWidget {
  const MaintenanceReportScreen({super.key});

  @override
  _MaintenanceReportScreenState createState() =>
      _MaintenanceReportScreenState();
}

class _MaintenanceReportScreenState extends State<MaintenanceReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          toolbarHeight: 110,
          backgroundColor: const Color.fromARGB(255, 18, 19, 26),
          title: Row(
            children: [
              Image.asset(
                'assets/images/FabriTrack logo.png',
                width: 90,
                height: 90,
              ),
              const SizedBox(width: 60),
              const Text(
                'Maintenance Report',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            // title: Text('$subNodeKey'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Motor Repair'),
              Tab(text: 'Belt Repair'),
              Tab(text: 'Roll Repair'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MaintenanceCategory(collectionName: 'motorrepair'),
            MaintenanceCategory(collectionName: 'beltrepair'),
            MaintenanceCategory(collectionName: 'rollrepair'),
          ],
        ),
      ),
    );
  }
}

class MaintenanceCategory extends StatelessWidget {
  final String collectionName;

  const MaintenanceCategory({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        final docs = snapshot.data?.docs;

        if (docs == null || docs.isEmpty) {
          return const Center(child: Text('No issues available.'));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final docSnapshot = docs[index];

            var issueData = docSnapshot.data() as Map<String, dynamic>;
            var issue = issueData['issue'] ?? '';
            var date = issueData['date']?.toDate() ?? DateTime.now();

            return ListTile(
              title: Text(issue),
              subtitle: Text('Date: ${date.toString()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
              ),
            );
          },
        );
      },
    );
  }
}
