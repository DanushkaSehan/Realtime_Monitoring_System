import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final TextEditingController _issueController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addIssue(String collectionName) async {
    if (_issueController.text.isNotEmpty && _selectedDate != null) {
      try {
        DateTime selectedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime?.hour ?? 0,
          _selectedTime?.minute ?? 0,
        );

        await FirebaseFirestore.instance.collection(collectionName).add({
          'issue': _issueController.text,
          'date': selectedDateTime,
        });

        _issueController.clear();
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Issue added successfully')));
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error adding issue')));
      }
    }
  }

  Future<void> showAllDataFromFirestore(BuildContext context) async {
    try {
      // Fetch data from the 'notifications' collection
      final querySnapshot =
          await FirebaseFirestore.instance.collection('notifications').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Create a list to store the data
        final List<Widget> dataList = [];

        for (final doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          final machine = data['issue'] ?? 'N/A';
          final issue = data['machine'] ?? 'N/A';
          final timestamp = data['timestamp']?.toString() ?? 'N/A';

          // Create a ListTile or any other widget to display the data
          final listItem = ListTile(
            title: Text('Machine: $machine'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Issue: $issue'),
                Text('Timestamp: $timestamp'),
              ],
            ),
          );

          // Add the ListTile to the dataList
          dataList.add(listItem);
        }

        // Create a dialog or navigate to a new screen to display the data
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Notifications'),
              content: SingleChildScrollView(
                child: Column(
                  children: dataList,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No data available')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error fetching data')));
    }
  }

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
                  'Maintenance Issues',
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
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 141, 84, 177),
                onPressed: () {
                  showAllDataFromFirestore(context);
                },
                tooltip: 'Action 2',
                child: Icon(Icons.notification_add_outlined),
              ),
              SizedBox(
                height: 8,
              ),
              FloatingActionButton.extended(
                backgroundColor: const Color.fromARGB(255, 141, 84, 177),
                onPressed: () async {
                  _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2050),
                  );

                  if (_selectedDate != null) {
                    _selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (_selectedTime != null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            title: const Text('Add Issue'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _issueController,
                                  decoration:
                                      const InputDecoration(labelText: 'Issue'),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addIssue('motorrepair');
                                  },
                                  child: const Text('Add to Motor'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addIssue('beltrepair');
                                  },
                                  child: const Text('Add to Belt'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addIssue('rollrepair');
                                  },
                                  child: const Text('Add to Roll'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                label: const Text('Add Issue'),
                icon: const Icon(Icons.add),
              ),
            ],
          )),
    );
  }
}

class MaintenanceCategory extends StatelessWidget {
  final String collectionName;

  const MaintenanceCategory({super.key, required this.collectionName});

  Future<void> _editIssue(
      BuildContext context, DocumentSnapshot docSnapshot) async {
    final issueData = docSnapshot.data() as Map<String, dynamic>;
    final TextEditingController editedIssueController =
        TextEditingController(text: issueData['issue']);
    DateTime? selectedDate = issueData['date']?.toDate();

    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text('Edit Issue'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editedIssueController,
                  decoration: const InputDecoration(labelText: 'Issue'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    String editedIssue = editedIssueController.text;
                    await docSnapshot.reference.update({
                      'issue': editedIssue,
                      'date': selectedDate,
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _deleteIssue(
      BuildContext context, DocumentSnapshot docSnapshot) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this issue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await docSnapshot.reference.delete();
    }
  }

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
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editIssue(context, docSnapshot),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteIssue(context, docSnapshot),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
