import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addfabric_details.dart';
import 'background_widget.dart';
import 'data_display.dart'; // Import your real-time data screen
import 'reports_screen.dart';
import 'request_maintenance.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> isSelected = [true, false]; // Initial state for ToggleButtons

  bool switchValue = false;
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

  final String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
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
        elevation: 20,
        shadowColor: Color.fromARGB(255, 59, 33, 102),
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
                      MaterialPageRoute(
                          builder: (context) => const FabricScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Add Fabric Details'.tr,
                  ),
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
                          builder: (context) => const DataScreen()),
                    );
                  },
                  icon: const Icon(Icons.account_tree_rounded),
                  label: Text('Real Time Tracking'.tr),
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
                          builder: (context) => const ReportsScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_chart),
                  label: Text('Reports'.tr),
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
                      MaterialPageRoute(builder: (context) => ReqMaintenance()),
                    );
                  },
                  icon: const Icon(Icons.add_ic_call),
                  label: Text('Request Maintenance'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        alignment:
            Alignment.topRight, // Align the switch to the top-right corner
        children: [
          // Your existing FloatingActionButton(s) or content

          // Add the switch as an overlay
          Positioned(
            top: 180, // Adjust the top position as needed
            right: 0, // Adjust the right position as needed

            child: SizedBox(
              height: 30,
              child: ToggleButtons(
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
          )
        ],
      ),
    );
  }
}
