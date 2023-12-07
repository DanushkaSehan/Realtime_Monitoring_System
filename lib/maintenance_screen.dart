import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bot_screens/chat_page.dart';
import 'signin_screen.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  List<bool> isSelected = [false, true]; // Initial state for ToggleButtons

  bool switchValue = true;
  Locale currentLocale = Locale('en', 'US'); // Default locale
  @override
  void initState() {
    super.initState();
    // Load saved switchValue and locale from SharedPreferences
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchValue = prefs.getBool('switchValue') ?? false;
      currentLocale = Locale(prefs.getString('localeLanguage') ?? 'si', 'SI');
    });
  }

  void savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('switchValue', switchValue);
    prefs.setString('localeLanguage', currentLocale.languageCode);
  }

  void _onToggle(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
        isSelected[buttonIndex] = buttonIndex == index;
      }
      if (index == 1) {
        currentLocale = Locale('si', 'SI');
      } else {
        currentLocale = Locale('en', 'US');
      }

      // Save switchValue and locale to SharedPreferences
      savePreferences();
      // Update locale using Get
      Get.updateLocale(currentLocale);
    });
  }

  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _machineController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addIssue(String collectionName) async {
    if (_machineController.text.isNotEmpty &&
        _issueController.text.isNotEmpty &&
        _selectedDate != null) {
      try {
        DateTime selectedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime?.hour ?? 0,
          _selectedTime?.minute ?? 0,
        );

        await FirebaseFirestore.instance.collection(collectionName).add({
          'machine': _machineController.text,
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
              title: Text('Notifications'.tr),
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
                  child: Text('Close'.tr),
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
      initialIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            elevation: 20,
            shadowColor: Color.fromARGB(255, 59, 33, 102),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'.tr),
                        content: Text('Are you sure you want to log out?'.tr),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Dismiss the dialog with "No"
                            },
                            child: Text('No'.tr),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                print("Signed Out");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()));
                              });
                            },
                            child: Text('Yes'.tr),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
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
                SizedBox(
                  height: 25,
                  child: ToggleButtons(
                    fillColor: Colors.white,
                    color: Colors.cyan,
                    borderColor: Colors.white,
                    selectedColor: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(25),
                    renderBorder: true,
                    isSelected: isSelected,
                    onPressed: _onToggle,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Text('EN')), // Icon for the first mode
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text('SI')), // Icon for the second mode
                    ],
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              indicator: BoxDecoration(
                color: Colors.deepPurple,
                //shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(30),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              splashBorderRadius: BorderRadius.circular(30),
              tabs: [
                Tab(
                  text: 'Motor Repair'.tr,
                ),
                Tab(text: 'Belt Repair'.tr),
                Tab(text: 'Roll Repair'.tr),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromARGB(166, 171, 184, 244),
              automaticIndicatorColorAdjustment: false,
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: GlowingOverscrollIndicator(
                    color: Colors.deepPurple,
                    axisDirection: AxisDirection.down,
                    child: MaintenanceCategory(collectionName: 'motorrepair')),
              ),
              GlowingOverscrollIndicator(
                  color: Colors.deepPurple,
                  axisDirection: AxisDirection.down,
                  child: Center(
                      child:
                          MaintenanceCategory(collectionName: 'beltrepair'))),
              GlowingOverscrollIndicator(
                  color: Colors.deepPurple,
                  axisDirection: AxisDirection.down,
                  child: Center(
                      child:
                          MaintenanceCategory(collectionName: 'rollrepair'))),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 141, 84, 177),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatPage()));
                },
                tooltip: 'Action 2',
                child: Icon(Icons.chat_outlined),
              ),
              SizedBox(
                height: 8,
              ),
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
                            title: Text('Add Issue'.tr),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _machineController,
                                  decoration: InputDecoration(
                                      labelText: 'Machine Number'.tr),
                                ),
                                TextField(
                                  controller: _issueController,
                                  decoration:
                                      InputDecoration(labelText: 'Issue'.tr),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addIssue('motorrepair');
                                  },
                                  child: Text('Add to Motor'.tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addIssue('beltrepair');
                                  },
                                  child: Text('Add to Belt'.tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addIssue('rollrepair');
                                  },
                                  child: Text('Add to Roll'.tr),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                label: Text('Add Issue'.tr),
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

    final TextEditingController editedmachineController =
        TextEditingController(text: issueData['machine']);
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
            title: Text('Edit Issue'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editedmachineController,
                  decoration: InputDecoration(labelText: 'Machine Number'.tr),
                ),
                TextField(
                  controller: editedIssueController,
                  decoration: InputDecoration(labelText: 'Issue'.tr),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    String editedIssue = editedIssueController.text;
                    String editedmachine = editedmachineController.text;

                    await docSnapshot.reference.update({
                      'issue': editedIssue,
                      'date': selectedDate,
                      'machine': editedmachine,
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text('Save'.tr),
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
          title: Text('Delete Confirmation'.tr),
          content: Text('Are you sure you want to delete this issue?'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: Text('Delete'.tr),
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
          return Center(child: Text('Network error'.tr));
        }

        final docs = snapshot.data?.docs;

        if (docs == null || docs.isEmpty) {
          return Center(child: Text('No issues available'.tr));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final docSnapshot = docs[index];

            var issueData = docSnapshot.data() as Map<String, dynamic>;
            var machine = issueData['machine'] ?? '';
            var issue = issueData['issue'] ?? '';
            var date = issueData['date']?.toDate() ?? DateTime.now();

            return ListTile(
              title: Text('$machine - $issue'),
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
